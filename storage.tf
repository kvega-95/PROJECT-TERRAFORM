# Stockage Game File

resource "azurerm_storage_account" "sagamingfiles" {
  name                = "stagamingfile"
  resource_group_name = azurerm_resource_group.resource_group.name

  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version           = "TLS1_2"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  allow_blob_public_access  = false
  large_file_share_enabled  = false

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["91.163.21.105"]
    virtual_network_subnet_ids = [azurerm_subnet.SUB-GAMING-GFILES.id]
  }

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  # Imperatif pour Azure Front Door
  static_website {}

  tags = {
    Environment = "PROD"
    Dept        = "IT"
    Project     = "GAMING"
  }
}

resource "azurerm_storage_container" "container-gamefiles" {
  name                 = "container-gamefiles"
  storage_account_name = azurerm_storage_account.sagamingfiles.name
}