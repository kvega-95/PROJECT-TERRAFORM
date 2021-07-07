# Provider Azure
provider "azurerm" {
  features {}
}

# Configuration d'un resource groupe pour les ressources
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.resource_location
}

# Creation du virtual network 
resource "azurerm_virtual_network" "vnet-gaming" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  address_space       = ["192.168.0.0/16"]

  tags = {
    Environment = "PROD"
    Dept        = "IT"
    Project     = "GAMING"
  }
}


# Creation des sous réseaux
resource "azurerm_subnet" "SUB-GAMING-INBOUND" {
  name                 = "SUB-GAMING-INBOUND"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet-gaming.name
  address_prefixes     = ["192.168.10.0/24"]
}

resource "azurerm_subnet" "SUB-GAMING-SQLINS" {
  name                 = "SUB-GAMING-SQLINS"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet-gaming.name
  address_prefixes     = ["192.168.20.0/24"]
  service_endpoints = ["Microsoft.Sql","Microsoft.Storage"]
}

resource "azurerm_subnet" "SUB-GAMING-GFILES" {
  name                 = "SUB-GAMING-GFILES"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet-gaming.name
  address_prefixes     = ["192.168.30.0/24"]
  service_endpoints = ["Microsoft.Storage"]
}
