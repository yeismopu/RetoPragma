variable "location" {
  default = "eastus"
}

variable "resource_group_name" {
  default = "rg-aks-ecommerce"
}

variable "aks_name" {
  default = "aks-ecommerce"
}

variable "acr_name" {
  default = "acrecommerce12345"
}

variable "sql_admin" {
  default = "sqladminuser"
}

variable "sql_password" {
  sensitive = true
}