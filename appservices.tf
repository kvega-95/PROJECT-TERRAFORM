# Configuration de l'App service

resource "azurerm_app_service" "appservice" {
  name                = "apigaming"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  https_only          = true


  site_config {
    linux_fx_version = "NODE|10.14"
    ip_restriction {
      virtual_network_subnet_id = azurerm_subnet.SUB-GAMING-SQLINS.id
    }
  }

  app_settings = {
    "SOME_KEY"                                   = "some-value"
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.appService-app_insights.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"        = "1.0.0"
    "DIAGNOSTICS_AZUREBLOBRETENTIONINDAYS"       = "35"
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS"         = "35"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
  }
  #Liaison avec le base SQL

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }

  #Spécification des dépendances

  depends_on = [
    azurerm_app_service_plan.appserviceplan,
    azurerm_application_insights.appService-app_insights
  ]
}

# Creation du AppService Plan pour l'exécution de notre application web

resource "azurerm_app_service_plan" "appserviceplan" {

  name                = "serviceplan-gaming"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  kind                = "linux"
  reserved            = true
  sku {
    tier = "Standard"
    size = "S1"
  }

}

# Scalabilité auto de notre AppService Plan

resource "azurerm_monitor_autoscale_setting" "appservice_autoscale" {
  name                = "AppService_AutoscaleSetting"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  target_resource_id  = azurerm_app_service_plan.appserviceplan.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 4
    }

  }


}