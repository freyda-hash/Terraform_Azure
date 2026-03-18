output "ressource_group_name" {
  description = "Resource group name for infra"
  value       = azurerm_resource_group.infra.name
}

output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.infra.id
}

output "subnet_id" {
  description = "Subnet ID for Azure Container Apps"
  value       = azurerm_subnet.infra.id
}