provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "test" { # deploying two resource groups
  count    = 2
  name     = element(var.rg, count.index)
  location = element(var.location, count.index)
  tags = {
    name = "prod"
  }
}
