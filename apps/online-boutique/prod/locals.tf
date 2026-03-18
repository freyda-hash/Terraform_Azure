// Tags communs utilisés par toutes les ressources
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

locals {
  # Nom  ACA de chaque app 
  app_name = {
    for svc, cfg in var.microservices :
    svc => "ob-${svc}-prod"
  }

  # Les ADDR pointe vers l'app ACA + port 80
  svc_http_addr = {
    for svc, cfg in var.microservices :
    svc => "${local.app_name[svc]}:80"
  }
}


locals {
  # env vars 
  service_env_overrides = {
    frontend = {
      ENABLE_PROFILER  = "0"
      ENABLE_ASSISTANT = "false"

      PRODUCT_CATALOG_SERVICE_ADDR    = lookup(local.svc_http_addr, "productcatalogservice", "")
      CURRENCY_SERVICE_ADDR       = lookup(local.svc_http_addr, "currencyservice", "")
      CART_SERVICE_ADDR           = lookup(local.svc_http_addr, "cartservice", "")
      RECOMMENDATION_SERVICE_ADDR = lookup(local.svc_http_addr, "recommendationservice", "")
      CHECKOUT_SERVICE_ADDR       = lookup(local.svc_http_addr, "checkoutservice", "")
      SHIPPING_SERVICE_ADDR       = lookup(local.svc_http_addr, "shippingservice", "")
      AD_SERVICE_ADDR             = lookup(local.svc_http_addr, "adservice", "")
      EMAIL_SERVICE_ADDR          = lookup(local.svc_http_addr, "emailservice", "")
      PAYMENT_SERVICE_ADDR        = lookup(local.svc_http_addr, "paymentservice", "")


      
      SHOPPING_ASSISTANT_SERVICE_ADDR = "disabled"
    }

    productcatalogservice = {
      DISABLE_PROFILER = "1"
    }

    currencyservice = {
      PORT             = "7000"
      DISABLE_PROFILER = "1"
    }

    cartservice = {
      REDIS_ADDR = "ob-redis-cart-prod:6379"
    }

    checkoutservice = {
      PORT            = "5050"
      ENABLE_TRACING  = "0"
      ENABLE_PROFILER = "0"

      PRODUCT_CATALOG_SERVICE_ADDR    = lookup(local.svc_http_addr, "productcatalogservice", "")
      CART_SERVICE_ADDR           = lookup(local.svc_http_addr, "cartservice", "")
      CURRENCY_SERVICE_ADDR       = lookup(local.svc_http_addr, "currencyservice", "")
      EMAIL_SERVICE_ADDR          = lookup(local.svc_http_addr, "emailservice", "")
      PAYMENT_SERVICE_ADDR        = lookup(local.svc_http_addr, "paymentservice", "")
      SHIPPING_SERVICE_ADDR       = lookup(local.svc_http_addr, "shippingservice", "")
    }

    shippingservice = {
      PORT            = "50051"
      DISABLE_PROFILER = "1"
    }

    paymentservice = {
      PORT            = "50051"
      DISABLE_PROFILER = "1"
    }

    emailservice = {
      PORT = "8080"
    }

    recommendationservice = {
      DISABLE_PROFILER = "1"
      PRODUCT_CATALOG_SERVICE_ADDR    = lookup(local.svc_http_addr, "productcatalogservice", "")
    }

    adservice = {
      DISABLE_STATS   = "1"
      DISABLE_TRACING = "1"
    }

  }
}
