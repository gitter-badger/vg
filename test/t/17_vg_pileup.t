#!/usr/bin/env bash

BASH_TAP_ROOT=../bash-tap
. ../bash-tap/bash-tap-bootstrap

PATH=..:$PATH # for vg


plan tests 1

# Compare output of pileup on tiny.vg and pileup/alignment.json
# with pileup/truth.json, which has been manually vetted.
# Will also test some vg view functionality. 
vg view -J -a -G pileup/alignment.json > alignment.gam
vg construct -r tiny/tiny.fa -v tiny/tiny.vcf.gz > tiny.vg
vg pileup tiny.vg alignment.gam > tiny.gpu
vg view tiny.gpu -l -j | jq . > tiny.gpu.json
is $(jq --argfile a tiny.gpu.json --argfile b pileup/truth.json -n '($a | (.. | arrays) |= sort) as $a | ($b | (.. | arrays) |= sort) as $b | $a == $b') true "vg pileup produces the expected output for test case on tiny graph."
rm -f alignment.gam tiny.vg tiny.gpu tiny.gpu.json
