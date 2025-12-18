# Create a resource group in Azure
resource "azurerm_resource_group" "example_az_rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "example_az_rg_dont_delete" {
  name     = "${var.rg_name}-dont-delete"
  location = var.location
  tags     = var.tags
  lifecycle {
    prevent_destroy = true
  }
}