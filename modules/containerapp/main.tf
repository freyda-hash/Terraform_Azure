resource "azurerm_container_app" "this" {
    name                         = var.name
    resource_group_name          = var.resource_group_name
    container_app_environment_id = var.container_app_environment_id
    revision_mode                = "Single"

    identity {
        type         = "UserAssigned"
        identity_ids = [var.user_assigned_identity_id]
    }

    dynamic "secret" {
        for_each = var.secrets
        content {
        name                = secret.key
        identity            = var.user_assigned_identity_id
        key_vault_secret_id = secret.value.key_vault_secret_id
        }
    }

    template {
        container {
        name   = "app"
        image  = var.image
        cpu    = var.cpu
        memory = var.memory

        dynamic "env" {
            for_each = var.env
            content {
            name  = env.key
            value = env.value
            }
        }
        }

        
        min_replicas = var.min_replicas
        max_replicas = var.max_replicas
        
    }

        ingress {
            external_enabled = var.ingress == "external"
            target_port      = var.port
            transport        = var.transport

            traffic_weight {
            percentage      = 100
            latest_revision = true
            }
    }

    lifecycle {
    create_before_destroy = true
    }
}
