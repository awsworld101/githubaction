provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "example1" {
  name     = "example-resources1"
  location = "West Europe"
}



data "azurerm_subnet" "example2" {
  name                 = "service"
  resource_group_name  = "example-resources"
  virtual_network_name = "example-network"
}

resource "azurerm_monitor_private_link_scope" "ampls" {
  name                = "example-amplss"
  resource_group_name = azurerm_resource_group.example1.name
}



# Create Private Endpint
resource "azurerm_private_endpoint" "endpoint" {
  name                = "koihijuhhvbhhfcgcgv_pe"
  resource_group_name = azurerm_resource_group.example1.name
  location            = azurerm_resource_group.example1.location
  subnet_id           = data.azurerm_subnet.example2.id
  private_service_connection {
    name                           = "kopiclohgjuhygujjb_psc"
    private_connection_resource_id = azurerm_monitor_private_link_scope.ampls.id
    is_manual_connection           = false
    subresource_names              = ["ampls"]
    
  }
}