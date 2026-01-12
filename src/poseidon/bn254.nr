// Instantiations of Poseidon constants, permutations and sponge for prime field of the same order as BN254
pub mod perm;
pub mod consts;

use crate::poseidon::absorb;
use super::permute;

// Variable-length Poseidon-128 sponge as suggested in second bullet point of section 3 of https://eprint.iacr.org/2019/458.pdf
#[field(bn254)]
pub fn sponge<let N: u32>(msg: [Field; N]) -> Field {
    absorb(consts::x5_5_config(), [0; 5], 4, 1, msg)[1]
}

// Creates state array with input at positions [1..N+1], then applies permutation
fn hash_internal<let N: u32, let STATE_SIZE: u32>(
    input: [Field; N],
    perm_fn: fn([Field; STATE_SIZE]) -> [Field; STATE_SIZE],
) -> Field {
    let mut state = [0; STATE_SIZE];
    for i in 0..N {
        state[i + 1] = input[i];
    }
    perm_fn(state)[0]
}

// Various instances of the Poseidon hash function
// Consistent with Circom's implementation
#[no_predicates]
pub fn hash_1(input: [Field; 1]) -> Field {
    hash_internal(input, perm::x5_2)
}

#[no_predicates]
pub fn hash_2(input: [Field; 2]) -> Field {
    hash_internal(input, perm::x5_3)
}

#[no_predicates]
pub fn hash_3(input: [Field; 3]) -> Field {
    hash_internal(input, perm::x5_4)
}

#[no_predicates]
pub fn hash_4(input: [Field; 4]) -> Field {
    hash_internal(input, perm::x5_5)
}

#[no_predicates]
pub fn hash_5(input: [Field; 5]) -> Field {
    hash_internal(input, perm::x5_6)
}

#[no_predicates]
pub fn hash_6(input: [Field; 6]) -> Field {
    hash_internal(input, perm::x5_7)
}

#[no_predicates]
pub fn hash_7(input: [Field; 7]) -> Field {
    hash_internal(input, perm::x5_8)
}

#[no_predicates]
pub fn hash_8(input: [Field; 8]) -> Field {
    hash_internal(input, perm::x5_9)
}

#[no_predicates]
pub fn hash_9(input: [Field; 9]) -> Field {
    hash_internal(input, perm::x5_10)
}

#[no_predicates]
pub fn hash_10(input: [Field; 10]) -> Field {
    hash_internal(input, perm::x5_11)
}

#[no_predicates]
pub fn hash_11(input: [Field; 11]) -> Field {
    hash_internal(input, perm::x5_12)
}

#[no_predicates]
pub fn hash_12(input: [Field; 12]) -> Field {
    hash_internal(input, perm::x5_13)
}

#[no_predicates]
pub fn hash_13(input: [Field; 13]) -> Field {
    hash_internal(input, perm::x5_14)
}

#[no_predicates]
pub fn hash_14(input: [Field; 14]) -> Field {
    hash_internal(input, perm::x5_15)
}

#[no_predicates]
pub fn hash_15(input: [Field; 15]) -> Field {
    hash_internal(input, perm::x5_16)
}

#[no_predicates]
pub fn hash_16(input: [Field; 16]) -> Field {
    hash_internal(input, perm::x5_17)
}
