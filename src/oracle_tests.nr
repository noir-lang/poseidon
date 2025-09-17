use super::poseidon2;

/// This calls the bb.js Poseidon2 implementation
#[oracle(getPoseidon2Hash)]
unconstrained fn poseidon2_hash_oracle(input: [Field; 10]) -> Field { }

unconstrained fn get_poseidon2_hash(input: [Field; 10]) -> Field {
    poseidon2_hash_oracle(input)
}

fn test_poseidon2_comparison(input: [Field; 10]) -> bool {
    // get  hash from Noir implementation
    let noir_hash = poseidon2::Poseidon2::hash(input, input.len());
    
    // get hash from bb.js via oracle
    let bb_hash = unsafe { get_poseidon2_hash(input) };
    
    noir_hash == bb_hash
}

#[test]
fn test_poseidon2(input: [Field; 10]) {
    let result = test_poseidon2_comparison(input);
    
    assert(result);
}
