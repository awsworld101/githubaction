provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "test" { # deploying two resource groups

  for_each = var.rg
  name     = each.key
  location = each.value.location
  tags     = var.tagname


}