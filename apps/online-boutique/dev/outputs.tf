output "resource_group_name" {
  value = azurerm_resource_group.apps.name
}

output "containerapps_environment_name" {
  value = azurerm_container_app_environment.aca_env.name
}

output "frontend_url" {
  # nom DNS public de la container app frontend
  value = try("https://${module.containerapp["frontend"].fqdn}", null)
}

output "blob_endpoint" {
  value = azurerm_storage_account.apps.primary_blob_endpoint
}

output "keyvault_uris" {
  value = { for svc, kv in azurerm_key_vault.svc : svc => kv.vault_uri }
}
