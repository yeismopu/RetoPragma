resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-ecommerce"

  network_profile {
  network_plugin    = "azure"
  load_balancer_sku = "standard"
  outbound_type     = "loadBalancer"

  service_cidr      = "172.16.0.0/16"
  dns_service_ip    = "172.16.0.10"
  }
  default_node_pool {
    name                = "system"
    vm_size             = "Standard_DS2_v2"
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    enable_auto_scaling = true
    min_count           = 3
    max_count           = 6
  }
  identity {
    type = "SystemAssigned"
  }
  api_server_access_profile {
  authorized_ip_ranges = ["186.115.70.250/32"]
  }


  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D2s_v3"
  mode                  = "User"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  enable_auto_scaling = true
  min_count           = 1
  max_count           = 5
  }