data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = "${var.gameserver_name}-${var.env}-kv"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy = [
    {
      tenant_id      = data.azurerm_client_config.current.tenant_id
      object_id      = data.azurerm_client_config.current.object_id
      application_id = null

      certificate_permissions = []
      key_permissions         = []
      storage_permissions     = []
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Purge",
      ]
    },
    {
      tenant_id     = data.azurerm_client_config.current.tenant_id
      object_id      = "9edd55d1-288c-482b-84a3-508efac9e683"
      application_id = null

      certificate_permissions = []
      key_permissions         = []
      storage_permissions     = []
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Purge",
      ]
    },
  ]

  tags = local.tags
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "privatekey" {
  name  = "${var.gameserver_name}-${var.env}-privatekey"
  value = tls_private_key.this.private_key_openssh
  tags  = local.tags
}

resource "azurerm_key_vault_secret" "publickey" {
  name  = "${var.gameserver_name}-${var.env}-publickey"
  value = tls_private_key.this.public_key_openssh
  tags  = local.tags
}

resource "random_string" "username" {
  keepers = {
    resource_group = local.resource_group_name
  }

  length = 12
}

resource "azurerm_key_vault_secret" "username" {
  name  = "${var.gameserver_name}-${var.env}-username"
  value = random_string.username.result
  tags  = local.tags
}
