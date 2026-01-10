use super::{poseidon, poseidon2};

/// This calls the bb.js Poseidon2 implementation
#[oracle(getPoseidon2Hash)]
unconstrained fn get_poseidon2_hash(input: [Field], message_size: u32) -> Field {}

/// This calls the poseidon-lite Poseidon implementation
#[oracle(getPoseidonHash)]
unconstrained fn get_poseidon_hash(input: [Field], message_size: u32) -> Field {}

#[test]
unconstrained fn test_poseidon2(input: [Field; 20]) {
    for i in 0..=20 {
        // get hash from Noir implementation
        let temp_size = i % (input.len() + 1);
        let noir_hash = poseidon2::Poseidon2::hash(input, temp_size);

        // get hash from bb.js via oracle
        let bb_hash = get_poseidon2_hash(input, temp_size);

        assert_eq(noir_hash, bb_hash);
    }
}

// Poseidon (original) oracle tests

#[test]
unconstrained fn test_poseidon_hash_1(input: [Field; 1]) {
    let noir_hash = poseidon::bn254::hash_1(input);
    let oracle_hash = get_poseidon_hash(input, 1);
    assert_eq(noir_hash, oracle_hash);
}

#[test]
unconstrained fn test_poseidon_hash_2(input: [Field; 2]) {
    let noir_hash = poseidon::bn254::hash_2(input);
    let oracle_hash = get_poseidon_hash(input, 2);
    assert_eq(noir_hash, oracle_hash);
}

#[test]
unconstrained fn test_poseidon_hash_3(input: [Field; 3]) {
    let noir_hash = poseidon::bn254::hash_3(input);
    let oracle_hash = get_poseidon_hash(input, 3);
    assert_eq(noir_hash, oracle_hash);
}

#[test]
unconstrained fn test_poseidon_hash_4(input: [Field; 4]) {
    let noir_hash = poseidon::bn254::hash_4(input);
    let oracle_hash = get_poseidon_hash(input, 4);
    assert_eq(noir_hash, oracle_hash);
}

#[test]
unconstrained fn test_poseidon_hash_8(input: [Field; 8]) {
    let noir_hash = poseidon::bn254::hash_8(input);
    let oracle_hash = get_poseidon_hash(input, 8);
    assert_eq(noir_hash, oracle_hash);
}
