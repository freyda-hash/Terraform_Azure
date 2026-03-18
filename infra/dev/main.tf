resource "azurerm_resource_group" "infra" {
  name     = "infra-dev"
  location = var.location

  tags = var.tags
}

resource "azurerm_virtual_network" "infra" {
  name                = "vnet-infra-dev"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name

  tags = var.tags
}

resource "azurerm_subnet" "infra" {
  name                 = "infra-dev"
  resource_group_name  = azurerm_resource_group.infra.name
  virtual_network_name = azurerm_virtual_network.infra.name
  address_prefixes     = ["10.10.0.0/23"]

  delegation {
    name = "aca-delegation"

    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      ]
    }
  }
  
}