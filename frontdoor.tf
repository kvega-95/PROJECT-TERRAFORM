# Configuration de la Porte d'entrée

resource "azurerm_frontdoor" "fd-gaming" {
  name = "fd-gaming"
  resource_group_name  = azurerm_resource_group.resource_group.name
  #location     = "global" /**** Warning donc commenté
  enforce_backend_pools_certificate_name_check = true

  frontend_endpoint {
    name                     = "fd-gaming"
    host_name                = "fd-gaming.azurefd.net"
    session_affinity_enabled = true
  }

  backend_pool {
    name = "fd-gaming-backend-pool"
    backend {
      host_header = azurerm_storage_account.sagamingfiles.primary_web_host
      address     = azurerm_storage_account.sagamingfiles.primary_web_host
      http_port   = 80
      https_port  = 443
      priority    = 1
      weight      = 50
    }

    health_probe_name   = "fd-gaming-backend-hp"
    load_balancing_name = "fd-gaming-backend-lb"
  }

  backend_pool_health_probe {
    name                = "fd-gaming-backend-hp"
    path                = "/"
    protocol            = "Https"
    probe_method        = "HEAD"
    interval_in_seconds = 120
  }

  backend_pool_load_balancing {
    name                            = "fd-gaming-backend-lb"
    sample_size                     = 4
    successful_samples_required     = 2
    additional_latency_milliseconds = 0
  }

  routing_rule {
    name               = "routing-rule-gaming"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["fd-gaming"]
    forwarding_configuration {
      forwarding_protocol           = "HttpsOnly"
      backend_pool_name             = "fd-gaming-backend-pool"
      cache_enabled                 = true
      cache_use_dynamic_compression = true
    }
  }

  tags = {
    Environment = "PROD"
    Dept        = "IT"
    Project     = "GAMING"
  }
}

resource "azurerm_frontdoor_custom_https_configuration" "fd_custom_https" {
  frontend_endpoint_id              = azurerm_frontdoor.fd-gaming.frontend_endpoint[0].id
  custom_https_provisioning_enabled = false
}