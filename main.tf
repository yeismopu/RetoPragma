resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location

  tags = {
    environment = var.environment
    project     = "aks-ecommerce"
  }
}

data "azurerm_client_config" "current" {}