use std::default::Default;
use std::hash::Hasher;

comptime global RATE: u32 = 3;

pub struct Poseidon2 {
    cache: [Field; 3],
    state: [Field; 4],
    cache_size: u32,
    squeeze_mode: bool, // 0 => absorb, 1 => squeeze
}

impl Poseidon2 {
    #[no_predicates]
    pub fn hash<let N: u32>(input: [Field; N], message_size: u32) -> Field {
        Poseidon2::hash_internal(input, message_size)
    }

    pub(crate) fn new(iv: Field) -> Poseidon2 {
        let mut result =
            Poseidon2 { cache: [0; 3], state: [0; 4], cache_size: 0, squeeze_mode: false };
        result.state[RATE] = iv;
        result
    }

    fn perform_duplex(&mut self) {
        // add the cache into sponge state
        self.state[0] += self.cache[0];
        self.state[1] += self.cache[1];
        self.state[2] += self.cache[2];
        self.state = crate::poseidon2_permutation(self.state, 4);
    }

    fn absorb(&mut self, input: Field) {
        assert(!self.squeeze_mode);
        if self.cache_size == RATE {
            // If we're absorbing, and the cache is full, apply the sponge permutation to compress the cache
            self.perform_duplex();
            self.cache[0] = input;
            self.cache_size = 1;
        } else {
            // If we're absorbing, and the cache is not full, add the input into the cache
            self.cache[self.cache_size] = input;
            self.cache_size += 1;
        }
    }

    fn squeeze(&mut self) -> Field {
        assert(!self.squeeze_mode);
        // If we're in absorb mode, apply sponge permutation to compress the cache.
        self.perform_duplex();
        self.squeeze_mode = true;

        // Pop one item off the top of the permutation and return it.
        self.state[0]
    }

    fn hash_internal<let N: u32>(input: [Field; N], in_len: u32) -> Field {
        let two_pow_64 = 18446744073709551616;
        let iv: Field = (in_len as Field) * two_pow_64;
        let mut state = [0; 4];
        state[RATE] = iv;

        if std::runtime::is_unconstrained() {
            for i in 0..(in_len / RATE) {
                state[0] += input[i * RATE];
                state[1] += input[i * RATE + 1];
                state[2] += input[i * RATE + 2];
                state = crate::poseidon2_permutation(state, 4);
            }

            // handle remaining elements after last full RATE-sized chunk
            let remainder_start = (in_len / RATE) * RATE;
            for j in remainder_start..in_len {
                state[j - remainder_start] += input[j];
            }
        } else {
            let mut states: [[Field; 4]; N / RATE + 1] = [[0; 4]; N / RATE + 1];
            states[0] = state;

            // process all full RATE-sized chunks, storing state after each permutation
            for chunk_idx in 0..(N / RATE) {
                for i in 0..RATE {
                    state[i] += input[chunk_idx * RATE + i];
                }
                state = crate::poseidon2_permutation(state, 4);
                states[chunk_idx + 1] = state;
            }

            // get state at the last full block before in_len
            let first_partially_filled_chunk = in_len / RATE;
            state = states[first_partially_filled_chunk];

            // handle remaining elements after last full RATE-sized chunk
            let remainder_start = (in_len / RATE) * RATE;
            for j in 0..RATE {
                let idx = remainder_start + j;
                if idx < in_len {
                    state[j] += input[idx];
                }
            }
        }

        // always run final permutation unless we just completed a full chunk
        // still need to permute once if in_len is 0
        if (in_len == 0) | (in_len % RATE != 0) {
            state = crate::poseidon2_permutation(state, 4)
        };

        state[0]
    }
}

pub struct Poseidon2Hasher {
    _state: [Field],
}

impl Hasher for Poseidon2Hasher {
    fn finish(self) -> Field {
        let iv: Field = (self._state.len() as Field) * 18446744073709551616; // iv = (self._state.len() << 64)
        let mut sponge = Poseidon2::new(iv);
        for i in 0..self._state.len() {
            sponge.absorb(self._state[i]);
        }
        sponge.squeeze()
    }

    fn write(&mut self, input: Field) {
        self._state = self._state.push_back(input);
    }
}

impl Default for Poseidon2Hasher {
    fn default() -> Self {
        Poseidon2Hasher { _state: @[] }
    }
}
