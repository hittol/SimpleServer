# ===================================================================
# Create SSH Key
# ===================================================================

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "./.key/azure_vm_key.pem"
  file_permission = "0600"
}

resource "azurerm_ssh_public_key" "vm_ssh_key" {
  name                = "vm-admin-key"
  resource_group_name = var.rg_name
  location            = var.location
  public_key          = tls_private_key.ssh_key.public_key_openssh
}

# ===================================================================
# Create PIP
# ===================================================================

resource "azurerm_public_ip" "Front-pip" {
  name                = "${var.Front_vm_name}-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


# ===================================================================

# ===================================================================
# Create NIC
# ===================================================================

resource "azurerm_network_interface" "nic_FrontVM"{
    name                        = "${var.Front_vm_name}-nic"
    location                    = var.location
    resource_group_name         = var.rg_name

    ip_configuration {
        name                            = var.ip_config_name
        subnet_id                       = var.Front-subnet_id
        private_ip_address_allocation   = var.ip_address_allocation
        private_ip_address              = var.Front_private_ip_address
        public_ip_address_id            = azurerm_public_ip.Front-pip.id
    }
}

resource "azurerm_network_interface" "nic_BackVM"{
    name                        = "${var.Back_vm_name}-nic"
    location                    = var.location
    resource_group_name         = var.rg_name

    ip_configuration {
        name                            = var.ip_config_name
        subnet_id                       = var.Back-subnet_id
        private_ip_address_allocation   = var.ip_address_allocation
        private_ip_address              = var.Back_private_ip_address
    }
}

resource "azurerm_network_interface" "nic_DBVM"{
    name                        = "${var.DB_vm_name}-nic"
    location                    = var.location
    resource_group_name         = var.rg_name

    ip_configuration {
        name                            = var.ip_config_name
        subnet_id                       = var.DB-subnet_id
        private_ip_address_allocation   = var.ip_address_allocation
        private_ip_address              = var.DB_private_ip_address
    }
}


# ===================================================================


# ===================================================================
# Create VM
# ===================================================================

resource "azurerm_linux_virtual_machine" "FrontVM" {
    name                    = var.Front_vm_name
    location                = var.location
    resource_group_name     = var.rg_name
    network_interface_ids   = [azurerm_network_interface.nic_FrontVM.id]
    size                    = var.App_VM_Size
    admin_username          = var.admin_username 

    os_disk {
        name                    = "${var.Front_vm_name}_osdisk"
        caching                 = var.vm_caching
        storage_account_type    = var.storage_account_type
        disk_size_gb            = var.App_Disk_Size 
    }

    source_image_reference {
        publisher = var.UbuntuServer.publisher
        offer     = var.UbuntuServer.offer
        sku       = var.UbuntuServer.sku
        version   = var.UbuntuServer.version
    }

    admin_ssh_key {
    username   = var.admin_username
    public_key = azurerm_ssh_public_key.vm_ssh_key.public_key
    }
}

resource "azurerm_linux_virtual_machine" "BackVM" {
    name                    = var.Back_vm_name
    location                = var.location
    resource_group_name     = var.rg_name
    network_interface_ids   = [azurerm_network_interface.nic_BackVM.id]
    size                    = var.App_VM_Size
    admin_username          = var.admin_username

    os_disk {
        name                    = "${var.Back_vm_name}_osdisk"
        caching                 = var.vm_caching
        storage_account_type    = var.storage_account_type
        disk_size_gb            = var.App_Disk_Size
    }

    source_image_reference {
        publisher = var.UbuntuServer.publisher
        offer     = var.UbuntuServer.offer
        sku       = var.UbuntuServer.sku
        version   = var.UbuntuServer.version
    }

    admin_ssh_key {
    username   = var.admin_username
    public_key = azurerm_ssh_public_key.vm_ssh_key.public_key
    }
}

resource "azurerm_linux_virtual_machine" "DBVM" {
    name                    = var.DB_vm_name
    location                = var.location
    resource_group_name     = var.rg_name
    network_interface_ids   = [azurerm_network_interface.nic_DBVM.id]
    size                    = var.DB_VM_Size
    admin_username          = var.admin_username

    os_disk {
        name                    = "${var.DB_vm_name}_osdisk"
        caching                 = var.vm_caching
        storage_account_type    = var.storage_account_type
        disk_size_gb            = var.DB_Disk_Size
    }

    source_image_reference {
        publisher = var.UbuntuServer.publisher
        offer     = var.UbuntuServer.offer
        sku       = var.UbuntuServer.sku
        version   = var.UbuntuServer.version
    }

    admin_ssh_key {
    username   = var.admin_username
    public_key = azurerm_ssh_public_key.vm_ssh_key.public_key
    }
}

