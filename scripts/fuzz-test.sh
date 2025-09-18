#!/usr/bin/env bash
set -e

# dependencies:
#
# - `nargo`
# - `node`
# - `yarn`

# Check for required dependencies
check_dependencies() {
    echo "🔍 Checking dependencies..."
    
    if ! command -v node &> /dev/null; then
        echo "Node.js is not installed. Please install Node.js >= 16.0.0"
        exit 1
    fi
    
    if ! command -v yarn &> /dev/null; then
        echo "Yarn is not installed. Please install Yarn"
        exit 1
    fi
    
    if ! command -v nargo &> /dev/null; then
        echo "Nargo is not installed. Please install the Noir compiler:"
        exit 1
    fi
    
    echo "All dependencies found"
}

# Install Node.js dependencies
install_dependencies() {
    echo "Setting up Node.js dependencies..."
    if [ ! -d "node_modules" ]; then
        echo "Installing Node.js dependencies..."
        yarn install
    else
        echo "Node.js dependencies already installed"
    fi
}

# Build TypeScript
build_typescript() {
    yarn build
}

# Start oracle server
start_oracle_server() {
    yarn start &
    ORACLE_PID=$!
    
    # Wait for server to start
    echo "Waiting for server to start..."
    sleep 3
    
    # Check if server is running
    if ! curl -s http://localhost:5555/health > /dev/null; then
        echo "oracle server failed to start"
        kill $ORACLE_PID 2>/dev/null || true
        exit 1
    fi
    
    echo "Oracle server is running"
}

# Run Noir tests
run_noir_tests() {
    echo "Running Noir tests with oracle..."
    nargo test --oracle-resolver http://localhost:5555
}

# Cleanup
cleanup() {
    echo "Stopping Oracle Server..."
    if [ ! -z "$ORACLE_PID" ]; then
        kill $ORACLE_PID 2>/dev/null || true
    fi
}

# Main execution
main() {
    echo "Poseidon2 Fuzz Testing against bb.js"
    echo "================================"
    
    check_dependencies
    install_dependencies
    
    nargo compile
    
    build_typescript
    start_oracle_server
    
    trap cleanup EXIT
    
    run_noir_tests
    
    echo "All oracle tests completed!"
}

# Run main function
main "$@"
