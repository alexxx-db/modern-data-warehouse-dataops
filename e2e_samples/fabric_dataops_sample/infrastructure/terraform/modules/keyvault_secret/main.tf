resource "azurerm_key_vault_secret" "secret" {
  name            = var.name
  value           = var.value
  key_vault_id    = var.key_vault_id
  expiration_date = var.expiration_date
  content_type    = var.content_type
  tags            = var.tags
}
