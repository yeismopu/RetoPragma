resource "azurerm_key_vault" "kv" {
  name                			= "kv-reto-pragma2-${var.environment}"
  location            			= azurerm_resource_group.rg.location
  resource_group_name 			= azurerm_resource_group.rg.name
  tenant_id           			= data.azurerm_client_config.current.tenant_id
  sku_name            			= "standard"
  public_network_access_enabled = false
  soft_delete_retention_days 	= 7
  purge_protection_enabled   	= true
}
resource "azurerm_role_assignment" "aks_kv_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}