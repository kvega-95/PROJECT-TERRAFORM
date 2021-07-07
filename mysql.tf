# Configuration serveur MySQL

resource "azurerm_mysql_server" "mysql-server" {
  name                = "sqlserver-gaming"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  administrator_login          = var.mysql-admin-login
  administrator_login_password = var.mysql-admin-password

  sku_name = "B_Gen5_1"
  version  = "8.0"

  storage_mb        = "5120"
  auto_grow_enabled = true

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

# Creation de la Database MySQL
resource "azurerm_mysql_database" "mysql-db" {
  name                = "mysqldatabase-gaming"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_mysql_server.mysql-server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

#Sécurisation de la base de donnée 

resource "azurerm_mysql_firewall_rule" "fw-rule" {
  name                = "fw-rule-gaming"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_mysql_server.mysql-server.name
  start_ip_address    = "91.163.21.105"
  end_ip_address      = "91.163.21.105"
}