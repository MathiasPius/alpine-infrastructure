#!/bin/sh
gpg --batch --use-agent --decrypt "$ANSIBLE_RUNNING_DIR"secrets/vault_pass.gpg
