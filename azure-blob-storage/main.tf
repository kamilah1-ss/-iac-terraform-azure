# Utwórz grupę zasobów
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Utwórz konto magazynu
resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
}

# Utwórz kontener magazynu Blob
resource "azurerm_storage_container" "example" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = var.storage_container_access_type
}

# Utwórz blok w kontenerze magazynu Blob
resource "azurerm_storage_blob" "example" {
  name                   = var.blob_name
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = var.blob_type
  source                 = var.blob_source
}
