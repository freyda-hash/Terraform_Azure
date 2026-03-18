run "apps_prod" {
  command = plan

  assert {
    condition     = var.location == "francecentral"
    error_message = "location doit être francecentral"
  }

  assert {
    condition     = contains(keys(var.microservices), "frontend")
    error_message = "microservices doit contenir la clé 'frontend'"
  }

   assert {
    condition     = var.microservices["frontend"].ingress == "external"
    error_message = "frontend doit être en ingress external"
  }


}
