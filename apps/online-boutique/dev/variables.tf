variable "location" {
  type        = string
  description = "Azure region"
  default     = "francecentral"
}

variable "project" {
  type        = string
  description = "terraform-esiea-lab"
}

variable "environment" {
  type        = string
  description = "Environment (dev)"
}

variable "stack" {
  type        = string
  description = "Stack (apps)"
}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "microservices" {
    description = "Map of microservices to deploy on ACA"
    type = map(object({
        image  = string
        port  = number
        ingress = string
        transport=string
        cpu  = number
        memory     = string
        min_replicas = number
        max_replicas = number
        env = map(string)
    }))
}