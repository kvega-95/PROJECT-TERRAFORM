# Declaration variables Resource Group
variable "resource_group_name" {
  description = "Nom de Resource Group"
  type        = string
}

variable "resource_location" {
  description = "Region par defaut Azure"
  type        = string
}

# Declaration variables VirtualNetwork
#
variable "vnet_name" {
  type        = string
  description = "Virtual Network name"
}

# Declaration variables MySQL

variable "mysql-admin-login" {
  type        = string
  description = "Login MySQL Server"
}

variable "mysql-admin-password" {
  type        = string
  description = "Mot de passe MySQL Server"
}