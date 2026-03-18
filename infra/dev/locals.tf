locals {
  common_tags = {
    owner       = "mboumba_perrine"
    school      = "ESIEA"
    module      = "tp-terraform-2026"
    environment = var.environment
    stack       = var.stack
    project     = var.project
  }
}
