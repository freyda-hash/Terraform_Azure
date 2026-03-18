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
  description = "Stack (infra)"
}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}