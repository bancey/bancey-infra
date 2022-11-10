resource "azurerm_linux_virtual_machine" "this" {
  count               = var.gameserver_count
  name                = "${var.gameserver_name}-${var.env}-vm${count.index + 1}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  size                = "Standard_D4as_v5"
  admin_username      = random_string.username.result
  network_interface_ids = [
    azurerm_network_interface.this[count.index].id
  ]

  admin_ssh_key {
    username   = random_string.username.result
    public_key = tls_private_key.this.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "this" {
  count              = var.gameserver_count
  virtual_machine_id = azurerm_linux_virtual_machine.this[count.index].id
  location           = local.resource_group_location
  enabled            = true

  daily_recurrence_time = "0000"
  timezone              = "GMT Standard Time"

  notification_settings {
    enabled = false
  }
}