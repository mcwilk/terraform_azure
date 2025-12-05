output "azurewm_rg_id" {
    description = "The ID of the Azure Resource Group"
    value       = azurerm_resource_group.example_az_rg.id
}

output "azure_rm_name" {
    description = "The name of the Azure Resource Group"
    value       = azurerm_resource_group.example_az_rg.name 
}

output "azure_vnet_id" {
    description = "The ID of the Azure Virtual Network"
    value       = azurerm_virtual_network.example_az_vnet.id
}

output "azure_vnet_name" {
    description = "The name of the Azure Virtual Network"
    value       = azurerm_virtual_network.example_az_vnet.name
}