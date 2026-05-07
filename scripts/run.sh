#!/usr/bin/env bash
set -eu

export PORT="${PORT:-8095}"
TS_SERVER_PID=""
project_dir="$(cd "$(dirname "$0")/.." && pwd)"

cleanup() {
    if [[ -n "$TS_SERVER_PID" ]]; then
        kill "$TS_SERVER_PID" 2>/dev/null || true
        wait "$TS_SERVER_PID" 2>/dev/null || true
    fi
}
trap cleanup EXIT

# Build TypeScript first
echo "Building TypeScript..."
yarn --cwd "$project_dir" build

# Start TypeScript RPC server in background
echo "Starting TypeScript RPC server..."
node "$project_dir/dist/oracle_server.js" &
TS_SERVER_PID=$!

# Wait for server to start
sleep 2

if ! kill -0 "$TS_SERVER_PID" 2>/dev/null; then
    echo "TypeScript RPC server failed to start" >&2
    exit 1
fi

# Run the Noir tests with oracle resolver
nargo --program-dir="$project_dir" test --oracle-resolver http://localhost:${PORT}
