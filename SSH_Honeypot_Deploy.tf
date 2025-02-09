terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"  # Specifies the version of the Azure provider
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "293caa52-ebff-42e6-9e6f-48771148aeed"  # Change this to your Azure subscription ID
}

# Virtual Network Configuration
resource "azurerm_virtual_network" "honeypot_vnet" {
  name                = "honeypot-vnet"
  location            = "West US"  # Change this to your desired Azure region
  resource_group_name = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"  # Change this to your resource group name
  address_space       = ["10.0.0.0/16"]  # Defines the address space for the virtual network
}

# Subnet Configuration
resource "azurerm_subnet" "honeypot_subnet" {
  name                 = "honeypot-subnet"
  resource_group_name  = azurerm_virtual_network.honeypot_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.honeypot_vnet.name
  address_prefixes     = ["10.0.1.0/24"]  # Defines the subnet range within the VNet
}

# Public IP Address
resource "azurerm_public_ip" "honeypot_public_ip" {
  name                = "honeypot-public-ip"
  location            = "West US"  # Change this if needed
  resource_group_name = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"  # Change this to your resource group name
  allocation_method   = "Static"  # Static IP allocation
}

# Network Security Group (NSG)
resource "azurerm_network_security_group" "honeypot_nsg" {
  name                = "honeypot-nsg"
  location            = "West US"  # Change this if needed
  resource_group_name = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"  # Change this to your resource group name

  # Allow SSH traffic
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

  # Allow HTTP traffic
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

  # Allow HTTPS traffic
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

# Network Interface
resource "azurerm_network_interface" "honeypot_nic" {
  name                = "honeypot-nic"
  location            = "West US"  # Change this if needed
  resource_group_name = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"  # Change this to your resource group name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.honeypot_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.honeypot_public_ip.id
  }
}

# Associate NSG with Network Interface
resource "azurerm_network_interface_security_group_association" "honeypot_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.honeypot_nic.id
  network_security_group_id = azurerm_network_security_group.honeypot_nsg.id
}

# Virtual Machine Configuration
resource "azurerm_virtual_machine" "honeypot_vm" {
  name                  = "honeypot-vm"
  location              = "West US"  # Change this if needed
  resource_group_name   = "learn-87970c21-3bea-4bf3-a1b4-2a51da775a76"  # Change this to your resource group name
  network_interface_ids = [azurerm_network_interface.honeypot_nic.id]
  vm_size               = "Standard_D2s_v3"  # Change this to a different VM size if needed

  # OS Disk Configuration
  storage_os_disk {
    name              = "honeypot-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 30  # Adjust disk size if needed
  }

  # OS Image Reference
  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"  # Ensures the latest version of Ubuntu is used
  }

  # OS Profile (Login Credentials)
  os_profile {
    computer_name  = "honeypot-vm"
    admin_username = "azureuser"  # Change this username if needed
    admin_password = "YourStrongPassword123!"  # Change this to a secure password
  }

  # Linux Configuration
  os_profile_linux_config {
    disable_password_authentication = false  # Set to true if using SSH keys instead
  }
}
