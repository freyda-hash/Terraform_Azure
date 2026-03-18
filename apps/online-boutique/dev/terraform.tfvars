project     = "terraform-esiea-lab"
environment = "dev"
stack       = "apps"
tags = {
  Owner       = "mboumba_perrine"
  School      = "ESIEA"
  Module      = "tp-terraform-2026"
}

microservices = {
  frontend = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/frontend:v0.10.4"
    port         = 8080
    ingress      = "external"
    transport    = "http"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 2
    env          = {}
  }

  productcatalogservice = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/productcatalogservice:v0.10.4"
    port         = 3550
    ingress      = "internal"
    transport    = "http2"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }

  currencyservice = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/currencyservice:v0.10.4"
    port         = 7000
    ingress      = "internal"
    transport    = "http2"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }

  cartservice = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/cartservice:v0.10.4"
    port         = 7070
    ingress      = "internal"
    transport    = "http2"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }

  checkoutservice = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/checkoutservice:v0.10.4"
    port         = 5050
    ingress      = "internal"
    transport    = "http2"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }

  shippingservice = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/shippingservice:v0.10.4"
    port         = 50051
    ingress      = "internal"
    transport    = "http2"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }

  paymentservice = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/paymentservice:v0.10.4"
    port         = 50051
    ingress      = "internal"
    transport    = "http2"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }

  emailservice = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/emailservice:v0.10.4"
    port         = 8080
    ingress      = "internal"
    transport    = "http2"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }

  recommendationservice = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/recommendationservice:v0.10.4"
    port         = 8080
    ingress      = "internal"
    transport    = "http2"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }

  adservice = {
    image        = "us-central1-docker.pkg.dev/google-samples/microservices-demo/adservice:v0.10.4"
    port         = 9555
    ingress      = "internal"
    transport    = "http2"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }

  redis-cart = {
    image        = "redis:alpine"
    port         = 6379
    ingress      = "internal"
    transport    = "tcp"
    cpu          = 0.25
    memory       = "0.5Gi"
    min_replicas = 1
    max_replicas = 1
    env          = {}
  }


}

