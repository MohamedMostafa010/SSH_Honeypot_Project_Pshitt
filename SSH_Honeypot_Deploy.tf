terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "293caa52-ebff-42e6-9e6f-48771148aeed"
}

resource "azurerm_virtual_network" "honeypot_vnet" {
  name                = "honeypot-vnet"
  location            = "West US"
  resource_group_name = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "honeypot_subnet" {
  name                 = "honeypot-subnet"
  resource_group_name  = azurerm_virtual_network.honeypot_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.honeypot_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "honeypot_public_ip" {
  name                = "honeypot-public-ip"
  location            = "West US"
  resource_group_name = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "honeypot_nsg" {
  name                = "honeypot-nsg"
  location            = "West US"
  resource_group_name = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "honeypot_nic" {
  name                = "honeypot-nic"
  location            = "West US"
  resource_group_name = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.honeypot_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.honeypot_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "honeypot_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.honeypot_nic.id
  network_security_group_id = azurerm_network_security_group.honeypot_nsg.id
}

resource "azurerm_virtual_machine" "honeypot_vm" {
  name                  = "honeypot-vm"
  location              = "West US"
  resource_group_name   = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"
  network_interface_ids = [azurerm_network_interface.honeypot_nic.id]
  vm_size               = "Standard_D2s_v3"

  storage_os_disk {
    name              = "honeypot-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 30
  }

  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_profile {
    computer_name  = "honeypot-vm"
    admin_username = "azureuser"
    admin_password = "YourStrongPassword123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}