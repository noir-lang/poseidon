# noir-library-starter

This repository is a template used by the noir-lang org when creating internally maintained libraries.

This provides out of the box:

- A simple CI setup to test and format the library
- A canary flagging up compilation failures on nightly releases.
- A [release-please](https://github.com/googleapis/release-please) setup to ease creating releases for the library.
- Contributing guidelines specified in [CONTRIBUTING.md](CONTRIBUTING.md)

Feel free to use this template as a starting point to create your own Noir libraries.

---

# LIBRARY_NAME

Add a brief description of the library

## Noir version compatibility

This library is tested to work as of Noir version 0.36.0 & 1.0.0-beta.x.

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
LIBRARY = { tag = "v0.1.0", git = "https://github.com/noir-lang/LIBRARY_NAME" }
```

## `library`

### Usage

`PLACEHOLDER`

