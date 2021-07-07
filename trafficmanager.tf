# Creation de nombres random pour la config DNS et le nom du Traffic Manager
resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }

  byte_length = 8
}

# Configuration Traffice Manager Profile
resource "azurerm_traffic_manager_profile" "traffic_manager" {
  name                   = "trafficmanager-gaming"
  resource_group_name    = azurerm_resource_group.resource_group.name
  traffic_routing_method = "Performance"

  # Setup the cname record in the DNS server so that DNS record is mapped to the Trafficmanger url
  dns_config {
    relative_name = random_id.server.hex
    ttl           = 100
  }
  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

}

# Configuration Traffic Manager Endpoint

resource "azurerm_traffic_manager_endpoint" "traffic_manager_endpoint" {
  name                = "trafficmanager-end-gaming"
  resource_group_name = azurerm_resource_group.resource_group.name
  profile_name        = azurerm_traffic_manager_profile.traffic_manager.name
  type                = "azureEndpoints"
  target_resource_id  = azurerm_app_service.appservice.id
}