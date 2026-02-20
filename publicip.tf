resource "azurerm_public_ip" "ingress_pip" {
  name                = "pip-aks-ingress"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  domain_name_label = "aks-ecommerce-demo"
}