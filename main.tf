# Create a resource group in Azure
resource "azurerm_resource_group" "example_az_rg" {
  name     = "HelloWorld_RG_TF"
  location = "East US"

  tags = {
    environment = "TerraformDemo"
  }
}

# Create a virtual network in the resource group
resource "azurerm_virtual_network" "example_az_vnet" {
  name          = "HelloWorld_VNET_TF"
  location      = azurerm_resource_group.example_az_rg.location
  resource_group_name = azurerm_resource_group.example_az_rg.name
  address_space = ["10.0.0.0/16"]

  subnet {
    name              = "HelloWorld_subnet_TF"
    address_prefixes  = ["10.0.1.0/24"]
  }

  tags = {
    environment = "TerraformDemo"
  }
}