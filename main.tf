# Configuración de Terraform y versión del proveedor
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Configuración del proveedor Azure
provider "azurerm" {
  features {}
}

# Grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "TechUStart-RG"
  location = var.azure_region
}

# Red virtual
resource "azurerm_virtual_network" "vnet" {
  name                = "TechUStart-VNet"
  address_space       = ["10.0.0.0/16"]
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name
}

# Subred
resource "azurerm_subnet" "subnet" {
  name                 = "TechUStart-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Dirección IP pública
resource "azurerm_public_ip" "public_ip" {
  name                = "TechUStart-PublicIP"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Grupo de seguridad de red
resource "azurerm_network_security_group" "nsg" {
  name                = "TechUStart-NSG"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name
}

# Regla para permitir tráfico HTTP por el puerto 80
resource "azurerm_network_security_rule" "http" {
  name                        = "AllowHTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Interfaz de red
resource "azurerm_network_interface" "nic" {
  name                = "TechUStart-NIC"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Asociación del grupo de seguridad con la interfaz de red
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Máquina virtual Linux
resource "azurerm_linux_virtual_machine" "vm" {

  name                = "TechUStart-VM"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.azure_region
  size                = var.tamano_vm
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  # Acceso mediante SSH
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyFGFWSRsfW/
    tcNHMfntDQ+9q0qv9ca3NbCehR2Z8l2EvnTO/rFEcbGG9fYdqk8w/F6mlJ7kCge20Y
    3VEFTWRqu5i77pZc1Zjge0n6VXt5+Of4WnFHoQKRcPgGK/CYFsWq9xn3cG2htsL31XONHI
    lXpyUKc159H+eLiNdTILY9juMJ9aYQ6d68gNYlrU0fmlj1ElUIe0sKZjMa9y4Mj6WUe//k7fHX
    ZpQjrJj+x86u+uX4VoKN7o1wJQL/E2V2mdRrJ8yZ1sy0H/ULBfSvFEgwAAFybvz3ORwoR+vHshNX4h6S
    PcmmbP1vaKXCcV49gDMYI0LGfsJaL2FwuDaXIhkB7Ut9SwA5pK83yyN5YNG4xry8NS4nmTmfCkYlsMxzm3O6zHm
    AcaJ/xk5cZstzWKMqygR7XFSHdi2gFj2g01/RcBFaxcF2YGbVLOyE4ugLn8AegoVLeFdJPK+QH0TG7ectKlbvPOSwu
    F5Hvig3BXDPFl2YZUg59/Dn4+KYFO13sf+iCLiO1EoLVkwbeSFl6TqWAh2RK22DlevoMhMbnbY+s60m/570YUsdC1ZNFf
    E05IcAETsFzIZOB6wI0QI5Fgl/hA/pHHvipBBv0uVVF/O4ACn97iAatPkv/+zQ+L0BmThalf5QXN0yMiJHbI+BQV14iolhE
    mpZ4GIXHubXZlUKsw== codespace@codespaces-acf64b"

  }

  # Configuración del disco
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Imagen de Ubuntu Server
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # Script para instalar Apache automáticamente
  custom_data = base64encode(<<EOF
#!/bin/bash
apt update
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
EOF
  )
}