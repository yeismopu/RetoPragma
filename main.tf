resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
    project     = "aks-ecommerce"
  }
}

data "azurerm_client_config" "current" {}