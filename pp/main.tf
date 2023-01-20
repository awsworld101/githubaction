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

data "azurerm_storage_account" "pp" {
  name                = "kopicloudnortheurope"
  resource_group_name = "network-rg"
}

resource "azurerm_resource_group" "testrg" {
  name     = "resourceGroupName"
  location = "westus"
}
resource "azure_private_endpoint" "endpoint" {
  name      = "kopicloudnortheurope_pe"
  subnet_id = azurerm_subnet.endpoint-subnet.id
  private_service_connection {
    name                           = "kopicloudnortheurope_psc"
    private_connection_resource_id = azurerm_storage_account.pp.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}