# Create a resource group in Azure
resource "azurerm_resource_group" "example_az_rg" {
  name     = var.rg_name
  location = var.location
  tags = var.tags
}

# Create a virtual network in the resource group
resource "azurerm_virtual_network" "example_az_vnet" {
  name          = "HelloWorld_VNET_TF"
  location      = azurerm_resource_group.example_az_rg.location
  resource_group_name = azurerm_resource_group.example_az_rg.name
  address_space = var.vnet_address_space

  subnet {
    name              = var.subnet_names[0]
    address_prefixes  = var.subnet_addresses[var.subnet_names[0]]
  }

  subnet {
    name              = var.subnet_names[1]
    address_prefixes  = var.subnet_addresses[var.subnet_names[1]]
  }

  tags = var.tags
}

resource "azurerm_subnet" "example_az_vnet_subnets" {
  for_each = var.subnets
  resource_group_name = azurerm_resource_group.example_az_rg.name
  virtual_network_name = azurerm_virtual_network.example_az_vnet.name
  name = each.key
  address_prefixes = each.value["address"]
}

# Create a virtual machine and all dependent resources
resource "azurerm_public_ip" "dev01vm_pub_ip" {
  name = "dev01vm-pub-ip-TF"
  resource_group_name = azurerm_resource_group.example_az_rg.name
  location = azurerm_resource_group.example_az_rg.location
  allocation_method = "Static"
}

resource "azurerm_network_interface" "dev01vm_nic" {
  name                = "dev01vm-nic-TF"
  location            = azurerm_resource_group.example_az_rg.location
  resource_group_name = azurerm_resource_group.example_az_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.example_az_vnet.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dev01vm_pub_ip.id
  }
}

resource "azurerm_network_security_group" "nsg_ssh" {
  name                = "dev01vm-nsg-TF"
  location            = azurerm_resource_group.example_az_rg.location
  resource_group_name = azurerm_resource_group.example_az_rg.name
  
  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.dev01vm_nic.id
  network_security_group_id = azurerm_network_security_group.nsg_ssh.id
}

resource "azurerm_linux_virtual_machine" "dev01vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.example_az_rg.name
  location            = azurerm_resource_group.example_az_rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser1"
  disable_password_authentication = ! var.enable_password_authentication

  network_interface_ids = [
    azurerm_network_interface.dev01vm_nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser1"
    public_key = file("./keys/terraform_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags
}
