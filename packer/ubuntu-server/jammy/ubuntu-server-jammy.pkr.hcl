proxmox_api_url = "https://192.168.80.11:8006/api2/json"
node = "baldr"
vm_id = 900
vm_name = "ubuntu-jammy-template"
template_description = "Ubuntu 22.04 (Jammy) Server Template"
iso_url = "https://releases.ubuntu.com/22.04.1/ubuntu-22.04.1-live-server-amd64.iso"
iso_checksum = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
username = "packer"
http_directory = "ubuntu-server/jammy/http"
files_directory = "ubuntu-server/jammy/files"

primary_provisioner_commands = [
  "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
  "sudo rm /etc/ssh/ssh_host_*",
  "sudo truncate -s 0 /etc/machine-id",
  "sudo apt -y autoremove --purge",
  "sudo apt -y clean",
  "sudo apt -y autoclean",
  "sudo cloud-init clean",
  "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
  "sudo sync"
]

secondary_provisioner_commands = [
  "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"
]