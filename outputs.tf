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
  value       = azurerm_public_ip.vm_pub_ip[*].ip_address
}

output "server_name" {
  description = "The name of the Azure Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm[*].name
}

output "admin_username" {
  description = "The admin username for the Azure Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm[*].admin_username
  sensitive   = true
}