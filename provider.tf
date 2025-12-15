provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = var.subscription_id
  # alias                           = "main_az"
  features {}
}