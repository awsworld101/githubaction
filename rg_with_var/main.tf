
resource "azurerm_resource_group" "example" {
  name     = var.name1
  location = var.loc1
}


resource "azurerm_resource_group" "example1" {
  name     = var.name2
  location = var.loc2
}

resource "azurerm_resource_group" "example2" {
  name     = var.name3
  location = var.loc2
}