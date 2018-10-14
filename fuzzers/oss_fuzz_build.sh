#!/bin/bash -eu

# build project
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX="$WORK" \
      -DBUILD_SHARED_LIBS=OFF \
      -DBUILD_CLAR=OFF \
      -DUSE_HTTPS=OFF \
      -DUSE_SSH=OFF \
      -DUSE_BUNDLED_ZLIB=ON \
      -DBUILD_FUZZERS=ON \
      -DUSE_OSS_FUZZ_BUILD=ON

make -j$(nproc)

for fuzzer in build/fuzzers/*_fuzzer
do
    fuzzer_name=$(basename "$fuzzer")
    cp "$fuzzer" "$OUT/$fuzzer_name"

    zip -j "$OUT/${fuzzer_name}_seed_corpus.zip" \
        ../fuzzers/corpora/${fuzzer_name%_fuzzer}/*
done
