use super::poseidon;

#[test]
fn reference_impl_test_vectors() {
    // hardcoded test vectors from https://extgit.iaik.tugraz.at/krypto/hadeshash/-/blob/master/code/test_vectors.txt
    {
        let mut state = [0, 1, 2];
        let mut expected = [
            0x115cc0f5e7d690413df64c6b9662e9cf2a3617f2743245519e19607a4417189a,
            0x0fca49b798923ab0239de1c9e7a4a9a2210312b6a2f616d18b5a87f9b628ae29,
            0x0e7ae82e40091e63cbd4f16a6d16310b3729d4b6e138fcf54110e2867045a30c,
        ];
        assert_eq(
            expected,
            poseidon::bn254::perm::x5_3(state),
            "Failed to reproduce output for [0, 1, 2]",
        );
    }
    {
        let mut state = [0, 1, 2, 3, 4];
        let mut expected = [
            0x299c867db6c1fdd79dcefa40e4510b9837e60ebb1ce0663dbaa525df65250465,
            0x1148aaef609aa338b27dafd89bb98862d8bb2b429aceac47d86206154ffe053d,
            0x24febb87fed7462e23f6665ff9a0111f4044c38ee1672c1ac6b0637d34f24907,
            0x0eb08f6d809668a981c186beaf6110060707059576406b248e5d9cf6e78b3d3e,
            0x07748bc6877c9b82c8b98666ee9d0626ec7f5be4205f79ee8528ef1c4a376fc7,
        ];
        assert_eq(
            expected,
            poseidon::bn254::perm::x5_5(state),
            "Failed to reproduce output for [0, 1, 2, 3, 4]",
        );
    }
}

#[test]
fn test_poseidon_hash_1() {
    // Test hash_1 function
    let input = [42];
    let hash = poseidon::bn254::hash_1(input);
    let expected = 0x1b408dafebeddf0871388399b1e53bd065fd70f18580be5cdde15d7eb2c52743;
    assert_eq(hash, expected);
}

#[test]
fn test_poseidon_hash_2() {
    let input = [1, 2];
    let hash = poseidon::bn254::hash_2(input);
    let expected = 0x115cc0f5e7d690413df64c6b9662e9cf2a3617f2743245519e19607a4417189a;
    assert_eq(hash, expected);
}

#[test]
fn test_poseidon_hash_4() {
    let input = [1, 2, 3, 4];
    let hash = poseidon::bn254::hash_4(input);
    let expected = 0x299c867db6c1fdd79dcefa40e4510b9837e60ebb1ce0663dbaa525df65250465;
    assert_eq(hash, expected);
}

#[test]
fn test_poseidon_hash_8() {
    let input = [1, 2, 3, 4, 5, 6, 7, 8];
    let hash = poseidon::bn254::hash_8(input);
    let expected = 0x2921ab9bd0140cbc98e40395c0fefb40337a4d54fbbecd9a4d43b3d8d0c4d8d1;
    assert_eq(hash, expected);
}
