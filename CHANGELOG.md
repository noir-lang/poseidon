# Changelog

## [0.2.2](https://github.com/noir-lang/poseidon/compare/v0.2.1...v0.2.2) (2026-01-19)


### Bug Fixes

* Remove OOB read from cache and unnecessary zeroing in `perform_duplex`  ([#33](https://github.com/noir-lang/poseidon/issues/33)) ([845fac9](https://github.com/noir-lang/poseidon/commit/845fac91fb3ba4a9c9434fe11a90f647a4137576))

## [0.2.1](https://github.com/noir-lang/poseidon/compare/v0.2.0...v0.2.1) (2026-01-16)


### Features

* Improve brillig performace ([#27](https://github.com/noir-lang/poseidon/issues/27)) ([596d59a](https://github.com/noir-lang/poseidon/commit/596d59add1222a57ad1e7dd229f7fa529aca6285))
* Optimize variable length hashes ([#32](https://github.com/noir-lang/poseidon/issues/32)) ([ec4b206](https://github.com/noir-lang/poseidon/commit/ec4b20658f1cf9dd7c7bc16ece935c66dcd21397))
* Remove cache in static length poseidon2 ([#28](https://github.com/noir-lang/poseidon/issues/28)) ([211d4e9](https://github.com/noir-lang/poseidon/commit/211d4e98fc7c2de6ba1994d97146f81cc358c2ba))
* Unroll poseidon2 hash loop by RATE chunks ([#30](https://github.com/noir-lang/poseidon/issues/30)) ([678300e](https://github.com/noir-lang/poseidon/commit/678300e3efbd4da9ee93c1be8819a03e9b6c03e5))

## [0.2.0](https://github.com/noir-lang/poseidon/compare/v0.1.1...v0.2.0) (2025-12-11)


### ⚠ BREAKING CHANGES

* remove variable length hash padding ([#15](https://github.com/noir-lang/poseidon/issues/15))

### Features

* Remove variable length hash padding ([#15](https://github.com/noir-lang/poseidon/issues/15)) ([af9b726](https://github.com/noir-lang/poseidon/commit/af9b72632b8fa3129140c2cda578d04cc991e28b))

## [0.1.1](https://github.com/noir-lang/poseidon/compare/v0.1.0...v0.1.1) (2025-05-22)


### Bug Fixes

* Always use u32 when indexing arrays ([#4](https://github.com/noir-lang/poseidon/issues/4)) ([e5fa393](https://github.com/noir-lang/poseidon/commit/e5fa3937f707046f28799243630c9011b08e29d4))

## 0.1.0 (2025-03-11)


### Features

* Initial release ([#1](https://github.com/noir-lang/poseidon/issues/1)) ([e20ea4a](https://github.com/noir-lang/poseidon/commit/e20ea4a7ccd8634a281c09244890b086182611b9))
