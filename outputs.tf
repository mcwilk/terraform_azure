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

output "azure_vm_public_ip" {
    description = "The Public IP address of the Azure Virtual Machine"
    value       = azurerm_public_ip.dev01vm_pub_ip.ip_address
}

output "server_name" {
    description = "The name of the Azure Virtual Machine"
    value       = azurerm_linux_virtual_machine.dev01vm.name
    sensitive   = true
}