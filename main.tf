# Create a resource group in Azure
resource "azurerm_resource_group" "example_az_rg" {
  name     = var.rg_name
  location = var.location

  tags = {
    environment = "TerraformDemo"
  }
}

# Create a virtual network in the resource group
resource "azurerm_virtual_network" "example_az_vnet" {
  name          = "HelloWorld_VNET_TF"
  location      = azurerm_resource_group.example_az_rg.location
  resource_group_name = azurerm_resource_group.example_az_rg.name
  address_space = var.vnet_address_space

  subnet {
    name              = "dev_subnet_TF"
    address_prefixes  = ["10.0.1.0/24"]
  }

  subnet {
    name              = "test_subnet_TF"
    address_prefixes  = ["10.0.2.0/24"]
  }

  tags = {
    environment = "TerraformDemo"
  }
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

  tags = {
    environment = "TerraformDemo"
  }
}