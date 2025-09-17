use super::poseidon2;

/// Oracle function that will be resolved by the JSON RPC server
/// This calls the bb.js Poseidon2 implementation
#[oracle(getPoseidon2Hash)]
unconstrained fn poseidon2_hash_oracle(input: [Field; 10]) -> Field { }

/// Wrapper function for the oracle
unconstrained fn get_poseidon2_hash(input: [Field; 10]) -> Field {
    poseidon2_hash_oracle(input)
}

/// Test function that compares Noir Poseidon2 with bb.js implementation
fn test_poseidon2_comparison(input: [Field; 10]) -> bool {
    // Get hash from Noir implementation
    let noir_hash = poseidon2::Poseidon2::hash(input, input.len());
    
    // Get hash from bb.js via oracle (unsafe block required)
    let bb_hash = unsafe { get_poseidon2_hash(input) };
    
    // Compare the results
    noir_hash == bb_hash
}

/// Test with specific input values
#[test]
fn test_poseidon2(input: [Field; 10]) {
    let result = test_poseidon2_comparison(input);
    
    assert(result);
}
