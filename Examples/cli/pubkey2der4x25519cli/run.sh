#!/bin/bash

mkdir -p ./sample.d

echo 'converting "public" key(random data) to PEM if it does not exist'
test -f ./sample.d/id.x25519.pem ||
  dd \
    if=/dev/urandom \
    of=/dev/stdout \
    bs=32 \
    count=1 \
    status=none |
    ./PubkeyToDerForX25519Cli |
    base64 |
    cat \
      <(printf '%s\n' '----BEGIN PUBLIC KEY-----') \
      /dev/stdin \
      <(printf '%s\n' '----END PUBLIC KEY-----') |
    dd \
      if=/dev/stdin \
      of=./sample.d/id.x25519.pem \
      bs=1048576 \
      status=none

echo
echo 'converting PEM to JWK...'
cat ./sample.d/id.x25519.pem |
  sed \
    -n \
    -e 2p |
  base64 --decode |
  node --eval '
    Promise.resolve("/dev/stdin")
    .then(require("node:fs/promises").readFile)
    .then(keyData => crypto.subtle.importKey(
      "spki",
      keyData,
      Object.freeze({name: "X25519"}),
      true,
      [],
    ))
    .then(spki => crypto.subtle.exportKey("jwk", spki))
    .then(JSON.stringify)
    .then(console.info)
  ' |
  jq
