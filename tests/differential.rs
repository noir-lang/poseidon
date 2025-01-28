use std::collections::BTreeMap;
use std::path::PathBuf;

use noir_runner::{NoirRunner, ToNoir};
use proptest::{prelude::prop, test_runner::TestRunner};

#[test]
fn test_prop_mul() {
    let runner = NoirRunner::try_new(PathBuf::new()).unwrap();

    let mut test_runner = TestRunner::new(Default::default());

    test_runner
        .run(&(0..1000u32, 0..1000u32), |(a, b)| {
            let input = BTreeMap::from([
                ("a".to_string(), a.to_noir()),
                ("b".to_string(), b.to_noir()),
            ]);

            let result = runner.run("prop_mul", input).unwrap().unwrap();

            let expected = a * b;

            assert_eq!(result, expected.to_noir());

            Ok(())
        })
        .unwrap();
}
