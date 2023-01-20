provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "server" { # deploying two resource groups
  count    = 2
  name     = "myrgh"
  location = "eastus"
  tags = {
    Name = "Server ${count.index + 1}"
  }
}



