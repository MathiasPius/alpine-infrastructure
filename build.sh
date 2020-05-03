#!/usr/bin/env bash
rm -rf images/
PACKER_KEY_INTERVAL=10ms packer build -var-file=distributions.pkrvar.hcl -var "hostname=$1" alpine.pkr.hcl