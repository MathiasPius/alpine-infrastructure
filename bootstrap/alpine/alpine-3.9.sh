#!/bin/sh

set -x

setup-keymap dk dk

# Enable networking using DHCP
setup-interfaces -i <<EOF
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
EOF

# Set a terrible root password that the following provisioning steps can use
echo "root:vmpass" | chpasswd

setup-apkrepos http://dl-cdn.alpinelinux.org/alpine/v3.9/main

# Configure OpenSSH to (temporarily) allow user/password connections.
apk add --quiet openssh python3 haveged
rc-update --quiet add sshd default
rc-update --quiet add haveged default
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

rc-update --quiet add networking boot
rc-update --quiet add urandom boot


# Install to /dev/vda
ERASE_DISKS=/dev/vda setup-disk -s 0 -m sys /dev/vda

reboot