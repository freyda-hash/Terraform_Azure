variable "name" { type = string }

variable "resource_group_name" { type = string }

variable "location" { type = string }

variable "container_app_environment_id" { type = string }

variable "image" { type = string }

variable "port" { type = number }

variable "ingress" { type = string }    # "internal" or "external"

variable "transport" { type = string }  # "http" | "http2" | "tcp"

variable "cpu" { type = number }

variable "memory" { type = string }

variable "min_replicas" { type = number }

variable "max_replicas" { type = number }

variable "env" {
  type    = map(string)
  default = {}
}

variable "user_assigned_identity_id" { type = string }


variable "secrets" {
  type = map(object({
    key_vault_secret_id = string
  }))
  default = {}
}
