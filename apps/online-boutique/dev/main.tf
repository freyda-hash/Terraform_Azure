
# Configuration de l'état distant pour l'application
data "terraform_remote_state" "infra" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-tfstate-mboumba"
    storage_account_name = "sttfstatemboumba001"
    container_name       = "tfstate"
    key                  = "infra-dev.tfstate"
  }
}




# Groupe de ressources pour l'application
resource "azurerm_resource_group" "apps" {
  name     = "online-boutique-dev"
  location = var.location
  tags     = local.common_tags
}


# Espace de travail Log Analytics pour l'application
resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-online-boutique-dev"
  location            = azurerm_resource_group.apps.location
  resource_group_name = azurerm_resource_group.apps.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}


# Environnement pour les applications conteneurisées
resource "azurerm_container_app_environment" "aca_env" {
  name                       = "online-boutique-env-apps-dev"
  location                   = azurerm_resource_group.apps.location
  resource_group_name        = azurerm_resource_group.apps.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  infrastructure_subnet_id = data.terraform_remote_state.infra.outputs.subnet_id

  tags = local.common_tags
}


# Compte de stockage pour l'application
resource "azurerm_storage_account" "apps" {
  name                     = "storageonlineboutiquedev" 
  resource_group_name      = azurerm_resource_group.apps.name
  location                 = azurerm_resource_group.apps.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"


  allow_nested_items_to_be_public = false
  tags = local.common_tags
}

# Génération de chaînes aléatoires pour les clés de coffre
resource "random_string" "kv" {
  for_each = var.microservices
  length   = 4
  upper    = false
  special  = false

  keepers = {
    service = each.key
    environment = var.environment
  }
}


# Ressources par microservice
# Groupe de ressources pour chaque microservice
resource "azurerm_resource_group" "svc" {
  for_each = var.microservices

  name     = "ob-${each.key}-dev"
  location = var.location
  tags     = local.common_tags
}

# Identité gérée pour chaque microservice
resource "azurerm_user_assigned_identity" "svc" {
  for_each            = var.microservices
  name                = "identity-${each.key}-dev"
  location            = var.location
  resource_group_name = azurerm_resource_group.svc[each.key].name
  tags                = local.common_tags
}

# Coffre de clés pour chaque microservice
resource "azurerm_key_vault" "svc" {
  for_each = var.microservices
  name                = lower("kv-${substr(each.key, 0, 8)}-${var.environment}-${random_string.kv[each.key].result}")
  location            = var.location
  resource_group_name = azurerm_resource_group.svc[each.key].name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  tags = local.common_tags
}


# Attribution du rôle Key Vault Secrets Officer
resource "azurerm_role_assignment" "kv_secrets_officer" {
  for_each             = var.microservices
  scope                = azurerm_key_vault.svc[each.key].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

#  Attribution du rôle Key Vault Secrets au service 
resource "azurerm_role_assignment" "kv_secrets_user_svc" {
  for_each             = var.microservices
  scope                = azurerm_key_vault.svc[each.key].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.svc[each.key].principal_id
}


# Délai d'attente pour la propagation des permissions RBAC
resource "time_sleep" "wait_kv_rbac" {
  for_each        = var.microservices
  create_duration = "30s"

  depends_on = [
    azurerm_role_assignment.kv_secrets_officer
  ]
}


# Secret fictif dans le coffre de clés
resource "azurerm_key_vault_secret" "dummy" {
  for_each     = var.microservices
  name         = "dummy-secret"
  value        = "dummy"
  key_vault_id = azurerm_key_vault.svc[each.key].id

  depends_on = [ azurerm_role_assignment.kv_secrets_officer ]
}



# Conteneur de stockage pour les assets de chaque microservice
resource "azurerm_storage_container" "assets" {
  for_each              = var.microservices
  name                  = "assets-${each.key}"
  storage_account_id    = azurerm_storage_account.apps.id
  container_access_type = "private"
}

# Attribution du rôle Storage Blob Data Reader
resource "azurerm_role_assignment" "blob_reader" {
  for_each             = var.microservices
  scope                = azurerm_storage_account.apps.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.svc[each.key].principal_id
}



# Déploiement des applications conteneurisées via module
module "containerapp" {
  for_each = var.microservices
  source   = "../../../modules/containerapp"

  name                         = "ob-${each.key}-dev"
  resource_group_name          = azurerm_resource_group.apps.name
  location                     = var.location
  container_app_environment_id = azurerm_container_app_environment.aca_env.id

  image     = each.value.image
  port      = each.value.port
  ingress   = each.value.ingress
  transport = each.value.transport

  cpu          = each.value.cpu
  memory       = each.value.memory
  min_replicas = each.value.min_replicas
  max_replicas = each.value.max_replicas

  user_assigned_identity_id = azurerm_user_assigned_identity.svc[each.key].id

  secrets = {
    "dummy-secret" = {
      key_vault_secret_id = azurerm_key_vault_secret.dummy[each.key].id
    }
  }

  depends_on = [
  azurerm_role_assignment.kv_secrets_user_svc,
  azurerm_key_vault_secret.dummy
  ]

  env = merge(each.value.env, lookup(local.service_env_overrides, each.key, {}), {
  BLOB_ENDPOINT  = azurerm_storage_account.apps.primary_blob_endpoint
  BLOB_CONTAINER = azurerm_storage_container.assets[each.key].name
  })

}
