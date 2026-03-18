run "infra_dev" {
  command = plan

  assert {
    condition     = var.location == "francecentral"
    error_message = "location doit être francecentral"
  }

  assert {
    condition     = azurerm_resource_group.infra.name == "infra-dev"
    error_message = "RG infra/dev doit s'appeler infra-dev"
  }

  assert {
    condition     = azurerm_virtual_network.infra.name == "vnet-infra-dev"
    error_message = "VNET infra/dev doit s'appeler vnet-infra-dev"
  }

  assert {
    condition     = azurerm_subnet.infra.delegation[0].service_delegation[0].name == "Microsoft.App/environments"
    error_message = "Subnet delegation doit être Microsoft.App/environments"
  }
}
