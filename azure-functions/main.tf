# main.tf

# Definiujemy zasoby Azure

# Tworzymy zasób grupy zasobów
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

# Tworzymy zasób konta magazynu
resource "azurerm_storage_account" "example" {
  name                     = "storageaccountexample"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Tworzymy plan usługi Azure App
resource "azurerm_app_service_plan" "example" {
  name                = "appserviceplanexample"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

# Tworzymy funkcję aplikacji Azure
resource "azurerm_function_app" "example" {
  name                       = "functionappexample"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
}

# Tworzymy funkcję aplikacji w funkcji aplikacji Azure
resource "azurerm_function_app_function" "example" {
  name                      = "${azurerm_function_app.example.name}/MyFunction"
  resource_group_name       = azurerm_resource_group.example.name
  function_app_name         = azurerm_function_app.example.name
  storage_account_name      = azurerm_storage_account.example.name
  storage_account_access_key= azurerm_storage_account.example.primary_access_key
  app_service_plan_id       = azurerm_app_service_plan.example.id
  https_only                = true

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "node"
  }
}

# Wyświetlamy ID dla funkcji aplikacji Azure
output "function_app_id" {
  value = azurerm_function_app.example.id
}
