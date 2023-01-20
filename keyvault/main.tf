
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "kv-rg" {
  name     = "kv-rg"
  location = "eastUS2"
}


resource "random_string" "random" {
  length  = 4
  special = false
}

data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "main" {
  name                        = "keyvaultforendpoint"
  location                    = azurerm_resource_group.kv-rg.location
  resource_group_name         = azurerm_resource_group.kv-rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization   = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
}