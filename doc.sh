#!/bin/sh

prod=PubkeyToDerX25519
numcpus=16
jobs=$((${numcpus} - 1))

docdir=./doc.d
mkdir -p "${docdir}"

swift \
	package \
	--jobs ${jobs} \
	--allow-writing-to-directory "${docdir}" \
	generate-documentation \
	--output-path "${docdir}" \
	--product "${prod}"
