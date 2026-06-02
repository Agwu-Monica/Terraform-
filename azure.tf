resource "azurerm_resource_group" "example" {
  name     = "terraf-rg"
  location = "North Europe"
}

resource "azurerm_network_security_group" "example" {
  name                = "terraf-security-group"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_virtual_network" "example" {
  name                = "terraf-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["192.168.0.0/16"]

  subnet {
    name             = "frontend-subnet"
    address_prefixes = ["192.168.0.0/24"]
  }

  subnet {
    name             = "backend-subnet"
    address_prefixes = ["192.168.1.0/24"]
  }

  tags = {
    environment = "Production"
  }
}

# NSG association (IMPORTANT - correct way)
resource "azurerm_subnet_network_security_group_association" "frontend" {
  subnet_id                 = azurerm_virtual_network.example.subnet[0].id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_virtual_network.example.subnet[1].id
  network_security_group_id = azurerm_network_security_group.example.id
}