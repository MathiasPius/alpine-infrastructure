variable "distributions" {
  type = map(map(map(map(string))))
}

variable "hostname" {
  type = string
}

variable "version" {
  type = string
  default = "3.9.4"
}

locals {
  alpine_version = lookup(var.distributions.alpine.versions, var.version, { })
}

source "qemu" "alpine" {
    vm_name = "${ var.hostname }.qcow2"
    accelerator = "kvm"
    headless = false
    disk_size = "256M"
    iso_checksum_type = local.alpine_version.iso_checksum_type
    iso_checksum = local.alpine_version.iso_checksum
    iso_url = local.alpine_version.iso_url
    ssh_username = "root"
    ssh_password = "vmpass"
    http_directory = "bootstrap"
    output_directory = "images"
    format = "qcow2"
    ssh_wait_timeout = "1h"
    shutdown_command = "/sbin/poweroff"
    boot_wait = "5s"
    boot_command = [
        "root<enter><wait>",
        "ip link set eth0 up && udhcpc -i eth0 &&<enter>",
        "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/alpine/${ local.alpine_version.setup_file } --output-document=setup.sh &&<enter>",
        "chmod +x setup.sh && ./setup.sh<enter>"
    ]
    qemuargs = [
        ["-device", "virtio-net,netdev=user.0"],
        ["-object", "rng-random,id=objrng0,filename=/dev/urandom"],
        ["-device", "virtio-rng-pci,rng=objrng0,id=rng0,bus=pci.0,addr=0x10"],
        ["-device", "virtio-vga"]
    ]
}

build {
  sources = [
    "source.qemu.alpine"
  ]

  provisioner "ansible" {
    playbook_file = "ansible/users.yml"
  }

  provisioner "ansible" {
    host_alias = var.hostname
    playbook_file = "ansible/sshd_config.yml"
  }
}