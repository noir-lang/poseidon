// Instantiations of Poseidon permutation for the prime field of the same order as BN254
use crate::poseidon::bn254::consts;
use crate::poseidon::permute;
use crate::poseidon::permute_first_element;

#[field(bn254)]
pub fn x5_2(mut state: [Field; 2]) -> [Field; 2] {
    state = permute(consts::x5_2_config(), state);

    state
}

#[field(bn254)]
pub fn x5_3(mut state: [Field; 3]) -> [Field; 3] {
    state = permute(consts::x5_3_config(), state);

    state
}

#[field(bn254)]
pub fn x5_4(mut state: [Field; 4]) -> [Field; 4] {
    state = permute(consts::x5_4_config(), state);

    state
}

#[field(bn254)]
pub fn x5_5(mut state: [Field; 5]) -> [Field; 5] {
    state = permute(consts::x5_5_config(), state);

    state
}

#[field(bn254)]
pub fn x5_6(mut state: [Field; 6]) -> [Field; 6] {
    state = permute(consts::x5_6_config(), state);

    state
}

#[field(bn254)]
pub fn x5_7(mut state: [Field; 7]) -> [Field; 7] {
    state = permute(consts::x5_7_config(), state);

    state
}

#[field(bn254)]
pub fn x5_8(mut state: [Field; 8]) -> [Field; 8] {
    state = permute(consts::x5_8_config(), state);

    state
}

#[field(bn254)]
pub fn x5_9(mut state: [Field; 9]) -> [Field; 9] {
    state = permute(consts::x5_9_config(), state);

    state
}

#[field(bn254)]
pub fn x5_10(mut state: [Field; 10]) -> [Field; 10] {
    state = permute(consts::x5_10_config(), state);

    state
}

#[field(bn254)]
pub fn x5_11(mut state: [Field; 11]) -> [Field; 11] {
    state = permute(consts::x5_11_config(), state);

    state
}

#[field(bn254)]
pub fn x5_12(mut state: [Field; 12]) -> [Field; 12] {
    state = permute(consts::x5_12_config(), state);

    state
}

#[field(bn254)]
pub fn x5_13(mut state: [Field; 13]) -> [Field; 13] {
    state = permute(consts::x5_13_config(), state);

    state
}

#[field(bn254)]
pub fn x5_14(mut state: [Field; 14]) -> [Field; 14] {
    state = permute(consts::x5_14_config(), state);

    state
}

#[field(bn254)]
pub fn x5_15(mut state: [Field; 15]) -> [Field; 15] {
    state = permute(consts::x5_15_config(), state);

    state
}

#[field(bn254)]
pub fn x5_16(mut state: [Field; 16]) -> [Field; 16] {
    state = permute(consts::x5_16_config(), state);

    state
}

#[field(bn254)]
pub fn x5_17(mut state: [Field; 17]) -> [Field; 17] {
    state = permute(consts::x5_17_config(), state);

    state
}

// Optimized versions that only return the first state element
// Used by hash functions which only need state[0]
// Reduces gate count by ~10-20% compared to full permutation

#[field(bn254)]
pub fn x5_2_first(state: [Field; 2]) -> Field {
    permute_first_element(consts::x5_2_config(), state)
}

#[field(bn254)]
pub fn x5_3_first(state: [Field; 3]) -> Field {
    permute_first_element(consts::x5_3_config(), state)
}

#[field(bn254)]
pub fn x5_4_first(state: [Field; 4]) -> Field {
    permute_first_element(consts::x5_4_config(), state)
}

#[field(bn254)]
pub fn x5_5_first(state: [Field; 5]) -> Field {
    permute_first_element(consts::x5_5_config(), state)
}

#[field(bn254)]
pub fn x5_6_first(state: [Field; 6]) -> Field {
    permute_first_element(consts::x5_6_config(), state)
}

#[field(bn254)]
pub fn x5_7_first(state: [Field; 7]) -> Field {
    permute_first_element(consts::x5_7_config(), state)
}

#[field(bn254)]
pub fn x5_8_first(state: [Field; 8]) -> Field {
    permute_first_element(consts::x5_8_config(), state)
}

#[field(bn254)]
pub fn x5_9_first(state: [Field; 9]) -> Field {
    permute_first_element(consts::x5_9_config(), state)
}

#[field(bn254)]
pub fn x5_10_first(state: [Field; 10]) -> Field {
    permute_first_element(consts::x5_10_config(), state)
}

#[field(bn254)]
pub fn x5_11_first(state: [Field; 11]) -> Field {
    permute_first_element(consts::x5_11_config(), state)
}

#[field(bn254)]
pub fn x5_12_first(state: [Field; 12]) -> Field {
    permute_first_element(consts::x5_12_config(), state)
}

#[field(bn254)]
pub fn x5_13_first(state: [Field; 13]) -> Field {
    permute_first_element(consts::x5_13_config(), state)
}

#[field(bn254)]
pub fn x5_14_first(state: [Field; 14]) -> Field {
    permute_first_element(consts::x5_14_config(), state)
}

#[field(bn254)]
pub fn x5_15_first(state: [Field; 15]) -> Field {
    permute_first_element(consts::x5_15_config(), state)
}

#[field(bn254)]
pub fn x5_16_first(state: [Field; 16]) -> Field {
    permute_first_element(consts::x5_16_config(), state)
}

#[field(bn254)]
pub fn x5_17_first(state: [Field; 17]) -> Field {
    permute_first_element(consts::x5_17_config(), state)
}
