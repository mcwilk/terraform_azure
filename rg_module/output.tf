output "azure_rg_id" {
  description = "The ID of the Azure Resource Group"
  value       = azurerm_resource_group.example_az_rg.id
}

output "azure_rg_name" {
  description = "The name of the Azure Resource Group"
  value       = azurerm_resource_group.example_az_rg.name
}

output "azure_rg_location" {
  description = "The location of the Azure Resource Group"
  value       = azurerm_resource_group.example_az_rg.location
}