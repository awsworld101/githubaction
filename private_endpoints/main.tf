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

resource "azurerm_resource_group" "network-rg" {
  name     = "network-rg"
  location = "north europe"
}
# Create the network VNET
resource "azurerm_virtual_network" "this" {
  name                = "network-vnet"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.network-rg.name
  location            = azurerm_resource_group.network-rg.location
}
# Create a subnet for endpoints
resource "azurerm_subnet" "endpoint-subnet" {
  name                 = "endpoint-subnet"
  address_prefixes     = ["10.0.10.0/24"]
  virtual_network_name = azurerm_virtual_network.this.name
  resource_group_name  = azurerm_resource_group.network-rg.name
  # private_endpoint_network_policies_enabled = true
}
# Create Private DNS Zone
resource "azurerm_private_dns_zone" "dns-zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network-rg.name
}
# Create Private DNS Zone Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  name                  = "kopicloudnortheurope_vnl"
  resource_group_name   = azurerm_resource_group.network-rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone.name
  virtual_network_id    = azurerm_virtual_network.this.id
}
# Create Storage Account
resource "azurerm_storage_account" "asa" {
  name                = "kopicloudnortheurope"
  resource_group_name = azurerm_resource_group.network-rg.name
  location            = azurerm_resource_group.network-rg.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
# Create Private Endpint
resource "azurerm_private_endpoint" "endpoint" {
  name                = "kopicloudnortheurope_pe"
  resource_group_name = azurerm_resource_group.network-rg.name
  location            = azurerm_resource_group.network-rg.location
  subnet_id           = azurerm_subnet.endpoint-subnet.id
  private_service_connection {
    name                           = "kopicloudnortheurope_psc"
    private_connection_resource_id = azurerm_storage_account.asa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
# Create DNS A Record
resource "azurerm_private_dns_a_record" "dns_a" {
  name                = "kopicloudnortheurope"
  zone_name           = azurerm_private_dns_zone.dns-zone.name
  resource_group_name = azurerm_resource_group.network-rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
}