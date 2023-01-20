terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}


data "azurerm_subnet" "endpoint-subnet" {
  name                 = "endpoint-subnet"
  virtual_network_name = "network-vnet"
  resource_group_name  = "network-rg"
}

data "azurerm_key_vault" "example" {
  name                = "keyvaultforendpoint"
  resource_group_name = "kv-rg"
}



resource "azurerm_resource_group" "kv-rggg" {
  name     = "kv-endpointt"
  location = "westUS"
}
resource "azurerm_private_endpoint" "main" {
  name                = "keyvaultendpoint"
  resource_group_name = azurerm_resource_group.kv-rggg.name
  location            = azurerm_resource_group.kv-rggg.location
  subnet_id           = data.azurerm_subnet.endpoint-subnet.id

  private_service_connection {
    is_manual_connection           = false
    private_connection_resource_id = data.azurerm_key_vault.example.id
    name                           = "keyvaultendpoint-psc"
    subresource_names              = ["vault"]
  }
}
