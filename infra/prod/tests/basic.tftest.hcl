run "infra_prod" {
  command = plan

  assert {
    condition     = var.location == "francecentral"
    error_message = "location doit être francecentral"
  }

  assert {
    condition     = azurerm_resource_group.infra.name == "infra-prod"
    error_message = "RG infra/prod doit s'appeler infra-prod"
  }

  assert {
    condition     = azurerm_virtual_network.infra.name == "vnet-infra-prod"
    error_message = "VNET infra/prod doit s'appeler vnet-infra-prod"
  }

  assert {
    condition     = azurerm_subnet.infra.delegation[0].service_delegation[0].name == "Microsoft.App/environments"
    error_message = "Subnet delegation doit être Microsoft.App/environments"
  }
}
