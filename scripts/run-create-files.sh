#!/usr/bin/env bash
FILES=30000

mkdir -p fstat-test
cd fstat-test

echo "Create a fstat-test directory with ${FILES} files.."
for seq in $(seq 1 $FILES); do
  touch "file${seq}"
done
