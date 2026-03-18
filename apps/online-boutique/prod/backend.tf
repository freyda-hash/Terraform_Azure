terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-mboumba"
    storage_account_name = "sttfstatemboumba001"
    container_name       = "tfstate"
    key                  = "apps/online-boutique/prod.tfstate"
  }
}
