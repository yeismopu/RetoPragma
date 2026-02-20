terraform {
  backend "azurerm" {
    resource_group_name   = "RG-IaC"
    storage_account_name  = "tfstateyeismopu"
    container_name        = "tfstate"
    key                   = "retopragma.tfstate"
  }
}