resource "azurerm_container_registry" "acr" {
  name                			= var.acr_name
  resource_group_name 			= azurerm_resource_group.rg.name
  location            			= azurerm_resource_group.rg.location
  sku                 			= "Standard"
  admin_enabled       			= false
  public_network_access_enabled = false
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}
