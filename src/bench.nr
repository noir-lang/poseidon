use super::{poseidon, poseidon2};

// Poseidon2 benchmarks
#[export]
fn poseidon2_hash_1(input: [Field; 1]) -> Field {
    poseidon2::Poseidon2::hash(input, input.len())
}

#[export]
fn poseidon2_hash_2(input: [Field; 2]) -> Field {
    poseidon2::Poseidon2::hash(input, input.len())
}

#[export]
fn poseidon2_hash_4(input: [Field; 4]) -> Field {
    poseidon2::Poseidon2::hash(input, input.len())
}

#[export]
fn poseidon2_hash_8(input: [Field; 8]) -> Field {
    poseidon2::Poseidon2::hash(input, input.len())
}

#[export]
fn poseidon2_hash_10(input: [Field; 10]) -> Field {
    poseidon2::Poseidon2::hash(input, input.len())
}

#[export]
fn poseidon2_hash_20(input: [Field; 20]) -> Field {
    poseidon2::Poseidon2::hash(input, input.len())
}

// Poseidon benchmarks
#[export]
fn poseidon_hash_1(input: [Field; 1]) -> Field {
    poseidon::bn254::hash_1(input)
}

#[export]
fn poseidon_hash_2(input: [Field; 2]) -> Field {
    poseidon::bn254::hash_2(input)
}

#[export]
fn poseidon_hash_4(input: [Field; 4]) -> Field {
    poseidon::bn254::hash_4(input)
}

#[export]
fn poseidon_hash_8(input: [Field; 8]) -> Field {
    poseidon::bn254::hash_8(input)
}

// Variable-length sponge benchmarks
#[export]
fn poseidon_sponge_1(input: [Field; 1]) -> Field {
    poseidon::bn254::sponge(input)
}

#[export]
fn poseidon_sponge_4(input: [Field; 4]) -> Field {
    poseidon::bn254::sponge(input)
}

#[export]
fn poseidon_sponge_8(input: [Field; 8]) -> Field {
    poseidon::bn254::sponge(input)
}

#[export]
fn poseidon_sponge_16(input: [Field; 16]) -> Field {
    poseidon::bn254::sponge(input)
}

#[export]
fn poseidon_sponge_32(input: [Field; 32]) -> Field {
    poseidon::bn254::sponge(input)
}