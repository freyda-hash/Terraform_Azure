output "id" {
  value = azurerm_container_app.this.id
}

output "fqdn" {
  value = try(azurerm_container_app.this.ingress[0].fqdn, null)
}

output "latest_revision_fqdn" {
  value = try(azurerm_container_app.this.latest_revision_fqdn, null)
}

output "identity_principal_id" {
  value = azurerm_container_app.this.identity[0].principal_id
}