resource "azurerm_resource_group" "strg" {
  name     = var.rg_name
  location = var.loc
}

resource "azurerm_storage_account" "strg" {
  name                     = "mystgnameee"
  resource_group_name      = azurerm_resource_group.strg.name
  location                 = azurerm_resource_group.strg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "strg" {
  name                  = var.con
  storage_account_name  = azurerm_storage_account.strg.name

  container_access_type = "private"
}