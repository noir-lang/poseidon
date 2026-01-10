use super::poseidon2;

#[export]
fn poseidon2_length_10(input: [Field; 20]) -> Field {
    poseidon2::Poseidon2::hash(input, input.len())
}
