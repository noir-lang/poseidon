# Poseidon Hashing Library

This package contains the Poseidon hashing interface, formerly in the Noir standard library.

## Noir version compatibility

This library is tested to work as of Noir version 0.36.0.

## Benchmarks

Benchmarks are ignored by `git` and checked on pull-request. As such, benchmarks may be generated
with the following command.

```bash
# execute the following
./scripts/build-gates-report.sh
```

The benchmark will be generated at `./gates_report.json`.

## Installation

In your _Nargo.toml_ file, add the version of this library you would like to install under dependency:

```toml
[dependencies]
poseidon = { tag = "v0.1.1", git = "https://github.com/noir-lang/poseidon" }
```

## Usage

You can import and use this library by doing:

```rust
use poseidon::poseidon2;

fn main(input: Field, expected: pub Field) {
    let reconstructed = poseidon2::Poseidon2::hash([input], 1);
    assert(expected == reconstructed);
}

#[test]
fn test_main() {
    let expected = 0x168758332d5b3e2d13be8048c8011b454590e06c44bce7f702f09103eef5a373; // poisedon2(1)

    main(1, expected);

    // Uncomment to make test fail
    // main(1, 0x2);
}

```
