variable "location" {
  default = "centralus"
}

variable "resource_group_name" {
  description = "Nombre base del resource group"
  type        = string
  default     = "rg-ecommerce"
}

variable "aks_name" {
  default = "aks-ecommerce"
}

variable "acr_name" {
  default = "acrecommerce01"
}

variable "sql_admin" {
  default = "sqladminuser"
}

variable "SQL_PASSWORD" {
  sensitive = true
}

variable "environment" {
  description = "Environment: dev o pdn según el branch"
  type        = string
}
