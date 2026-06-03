resource "azurerm_resource_group" "example" {
  name     = "terraf-resources"
  location = "North Europe"
}

resource "azurerm_network_security_group" "frontend-nsg" {
  name                = "terraf-frontend-nsg" # Given a unique Azure name
  location            = azurerm_resource_group.example.location # Fixed from .rg.
  resource_group_name = azurerm_resource_group.example.name     # Fixed from .rg.
}

resource "azurerm_network_security_group" "backend-nsg" {
  name                = "terraf-backend-nsg" # Given a unique Azure name
  location            = azurerm_resource_group.example.location # Fixed from .rg.
  resource_group_name = azurerm_resource_group.example.name     # Fixed from .rg.
}

resource "azurerm_virtual_network" "terraf-vnet" {
  name                = "terraf-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name             = "frontend-subnet"
    address_prefixes = ["10.0.1.0/24"]
    security_group   = azurerm_network_security_group.frontend-nsg.id
  }

  subnet {
    name             = "backend-subnet"
    address_prefixes = ["10.0.2.0/24"]
    security_group   = azurerm_network_security_group.backend-nsg.id
  }

  tags = {
    environment = "Production"
  }
}