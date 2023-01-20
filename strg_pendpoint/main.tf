
data "azurerm_subnet" "endpoint-subnet" {
  name                 = "endpoint-subnet"
  virtual_network_name = "network-vnet"
  resource_group_name  = "network-rg"
}

data "azurerm_storage_account" "asa" {
  name                = "kopicloudnortheurope"
  resource_group_name = "network-rg"
}

resource "azurerm_resource_group" "testrg" {
  name     = "resourceGroupName"
  location = "north europe"

}
resource "azurerm_private_endpoint" "endpoint" {
  name                = "kopicloudnortheuropeeeeone_pe"
  resource_group_name = azurerm_resource_group.testrg.name
  location            = azurerm_resource_group.testrg.location
  subnet_id           = data.azurerm_subnet.endpoint-subnet.id
  private_service_connection {
    name                           = "kopicloudnortheurope_psc"
    private_connection_resource_id = data.azurerm_storage_account.asa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}