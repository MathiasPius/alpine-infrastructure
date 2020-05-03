#!/bin/sh
PKIPATH="${ANSIBLE_RUNNING_DIR:-$(dirname $(dirname $0))}/secrets"
gpg --batch --use-agent --decrypt "$PKIPATH"/vault_pass.gpg
