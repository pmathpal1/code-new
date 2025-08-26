# Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

# Storage Container
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

# Output for backend config
output "backend_config" {
  value = {
    resource_group_name  = azurerm_resource_group.rg.name
    storage_account_name = azurerm_storage_account.sa.name
    container_name       = azurerm_storage_container.container.name
    key                  = "terraform.tfstate"
  }
}
