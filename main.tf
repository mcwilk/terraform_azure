locals {
  std_prefix = lower("${var.prefix}-${var.env}")
}

module "rg_mod" {
  source = "./rg_module"

}

# Create a virtual network in the resource group
resource "azurerm_virtual_network" "example_az_vnet" {
  name                = "HelloWorld_VNET_TF"
  location            = module.rg_mod.azure_rg_location
  resource_group_name = module.rg_mod.azure_rg_name
  address_space       = var.vnet_address_space

  subnet {
    name             = var.subnet_names[0]
    address_prefixes = var.subnet_addresses[var.subnet_names[0]]
  }

  subnet {
    name             = var.subnet_names[1]
    address_prefixes = var.subnet_addresses[var.subnet_names[1]]
  }
}

resource "azurerm_subnet" "example_az_vnet_subnets" {
  for_each             = var.subnets
  resource_group_name  = module.rg_mod.azure_rg_name
  virtual_network_name = azurerm_virtual_network.example_az_vnet.name
  name                 = each.key
  address_prefixes     = each.value["address"]
}

# Create a virtual machine and all dependent resources
resource "azurerm_public_ip" "vm_pub_ip" {
  count               = var.number_of_vm
  name                = "${local.std_prefix}-${var.vm_name}-${format("%02s", count.index + 1)}-pub-ip-TF"
  resource_group_name = module.rg_mod.azure_rg_name
  location            = module.rg_mod.azure_rg_location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm_nic" {
  count               = var.number_of_vm
  name                = "${local.std_prefix}-${var.vm_name}-${format("%02s", count.index + 1)}-nic-TF"
  resource_group_name = module.rg_mod.azure_rg_name
  location            = module.rg_mod.azure_rg_location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.example_az_vnet.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pub_ip[count.index].id
  }
}

resource "azurerm_network_security_group" "nsg_ssh" {
  name                = "${local.std_prefix}-${var.vm_name}-nsg-TF"
  resource_group_name = module.rg_mod.azure_rg_name
  location            = module.rg_mod.azure_rg_location

  dynamic "security_rule" {
    for_each = var.firewall_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value["priority"]
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  count                     = var.number_of_vm
  network_interface_id      = azurerm_network_interface.vm_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg_ssh.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                           = var.number_of_vm == 1 ? 0 : var.number_of_vm # 2
  name                            = "${local.std_prefix}-${var.vm_name}-${format("%02s", count.index + 1)}"
  resource_group_name             = module.rg_mod.azure_rg_name
  location                        = module.rg_mod.azure_rg_location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser1"
  disable_password_authentication = !var.enable_password_authentication

  network_interface_ids = [
    azurerm_network_interface.vm_nic[count.index].id,
  ]

  admin_ssh_key {
    username   = "azureuser1"
    public_key = file("./keys/terraform_key.pub")
  }

  os_disk {
    name                 = "${local.std_prefix}-${var.vm_name}-${format("%02s", count.index + 1)}-osdisk-TF"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "random_id" "sa_suffix" {
  byte_length = 8
  keepers = {
    "sa" = var.sa_prefix
  }
}

resource "azurerm_storage_account" "my_random_sa" {
  name                     = lower("${var.sa_prefix}${random_id.sa_suffix.hex}")
  resource_group_name      = module.rg_mod.azure_rg_name
  location                 = module.rg_mod.azure_rg_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier = "Cool"
  lifecycle {
    ignore_changes = [ access_tier ]
  }
}