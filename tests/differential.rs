use acvm::{AcirField, FieldElement};
use std::collections::BTreeMap;
use std::path::PathBuf;

use ark_bn254;
use noir_runner::{InputValue, NoirRunner, ToNoir};
use proptest::prelude::*;
use proptest::{prelude::prop, strategy::Strategy, test_runner::TestRunner};

#[test]
fn fuzz_poseidon_1_equivalence() {
    use light_poseidon::{Poseidon, PoseidonHasher};
    let poseidon_hash = |inputs: &[FieldElement]| {
        let mut poseidon = Poseidon::<ark_bn254::Fr>::new_circom(inputs.len()).unwrap();
        let frs: Vec<ark_bn254::Fr> = inputs.iter().map(|f| f.into_repr()).collect::<Vec<_>>();
        let hash: ark_bn254::Fr = poseidon.hash(&frs).expect("failed to hash");
        FieldElement::from_repr(hash)
    };

    let runner = NoirRunner::try_new(PathBuf::new()).unwrap();
    let mut test_runner = TestRunner::new(Default::default());
    let strategy = field_vec_strategy(16);
    let _ = test_runner.run(&strategy, |msg| {
        let expected = poseidon_hash(&msg);
        let input = BTreeMap::from([
            ("input".to_string(), msg.clone().to_noir()),
            ("len".to_string(), msg.len().to_noir()),
        ]);
        let result = runner.run("poseidon_hash_1", input);
        prop_assert_eq!(expected.to_noir(), result.unwrap().unwrap());
        Ok(())
    });
}

pub(crate) fn field_vec_strategy(len: usize) -> impl Strategy<Value = Vec<acvm::FieldElement>> {
    // Generate Field elements from random 32 byte vectors.
    let field = prop::collection::vec(any::<u8>(), 32)
        .prop_map(|bytes| FieldElement::from_be_bytes_reduce(&bytes));

    prop::collection::vec(field, len)
}
