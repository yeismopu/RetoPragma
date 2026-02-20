resource "azurerm_mssql_server" "sql" {
  name                          = "sqlecommerce12345"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  version                       = "12.0"
  public_network_access_enabled = false
  administrator_login           = var.sql_admin
  administrator_login_password  = var.SQL_PASSWORD
}

resource "azurerm_mssql_database" "db" {
  name           = "ecommerce-db"
  server_id      = azurerm_mssql_server.sql.id
  sku_name       = "GP_S_Gen5_2"
  zone_redundant = false
}

resource "azurerm_redis_cache" "redis" {
  name                			= "redisecommerce123"
  location            			= azurerm_resource_group.rg.location
  resource_group_name 			= azurerm_resource_group.rg.name
  public_network_access_enabled = false
  capacity            			= 1
  family              			= "C"
  sku_name            			= "Standard"
  minimum_tls_version 			= "1.2"
}