resource "cloudflare_record" "records" {
  count   = var.gameserver_count
  zone_id = data.azurerm_key_vault_secret.cloudflare_main_zone_id.value
  name    = "${var.gameserver_name}${count.index + 1}-${var.env}"
  value   = azurerm_public_ip.this[count.index].ip_address
  type    = "A"
  proxied = false
  ttl     = 100
}
