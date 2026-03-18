run "plan_containerapp_module" {
  command = plan

  variables {
    name                         = "ob-frontend-dev"
    resource_group_name          = "rg-dummy"
    container_app_environment_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.App/managedEnvironments/env"

    image     = "nginx:latest"
    port      = 8080
    ingress   = "external"
    transport = "http"

    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 0
    max_replicas = 1

    user_assigned_identity_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id"

    secrets = {
      "dummy-secret" = {
        key_vault_secret_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv/secrets/dummy-secret"
      }
    }

    env = {
      TEST = "ok"
    }
  }

  

  assert {
    condition     = length(var.name) <= 32
    error_message = "name containerapp doit être <= 32 caractères"
  }


}
