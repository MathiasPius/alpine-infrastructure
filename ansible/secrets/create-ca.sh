#!/usr/bin/env bash
ssh-keygen -t ed25519 -a 1000 -f root-ca -N "" -C "Root Certificate"
ansible-vault encrypt root-ca