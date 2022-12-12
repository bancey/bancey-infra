module "thor-replica" {
  source = "../../modules/proxmox-vm"

  target_node    = "wanda"
  vm_name        = "thor replica"
  vm_description = "Temporary migration VM to allow me to decommission the physical host."
  cpu_cores      = 2
  memory         = 8192
  ip_address     = "192.168.80.20"
  startup_order  = 15
  startup_delay  = 0
}
