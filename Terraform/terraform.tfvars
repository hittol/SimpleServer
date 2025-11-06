# ===================================================================
# Resource Group Variables
# ===================================================================

location = "koreacentral"

rg_setting = {
  "MainRG" = {
    name     = "RG-DH-Cloud"
    location = "koreacentral"
  }
}


# ===================================================================
# VNET Variables
# ===================================================================

hub_vnet_name               = "hub-vnet"
hub_vnet_address_space      = ["10.0.0.0/16"]
hub_subnets = {
    "FrontSubnet"                     = {
      address_prefixes                = ["10.0.0.0/24"]
      nsg_key                         = "Front-nsg"
    },
    "BackSubnet"                      = {
      address_prefixes                = ["10.0.1.0/24"]
      nsg_key                         = "Back-nsg"
    },
    "DBSubnet"                        = {
      address_prefixes                = ["10.0.2.0/24"]
      nsg_key                         = "DB-nsg"
    },
    "AzureApplicationGatewaySubnet"   = {
      address_prefixes                = ["10.0.3.0/24"]
    }
}

nsg_rule    = {
  "Front-nsg" = {
    rules = [
      {
        name                       = "AllowSSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "22"
        source_address_prefix      = "*"
      },
      {
        name                       = "AllowAppGW"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "80"
        source_address_prefix      = "10.0.3.0/24"
      },     
      {
        name                       = "AllowFromBack"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "*"
        source_address_prefix      = "10.0.1.0/24"
      }
    ]
  },
  "Back-nsg" = {
    rules = [
      {
        name                       = "AllowFromFront"
        priority                   = 300
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "*"
        source_address_prefix      = "10.0.0.0/24"
      },
      {
        name                       = "DenyFromAll"
        priority                   = 700
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        destination_port_range     = "*"
        source_address_prefix      = "*"
      },
      {
        name                       = "AllowToDB"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "*"
        source_address_prefix      = "10.0.2.0/24"
      }     
    ]
  },
  "DB-nsg" = {
    rules = [
      {
        name                       = "AllowFromBack"
        priority                   = 300
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "*"
        source_address_prefix      = "10.0.1.0/24"
      },
      {
        name                       = "DenyToAll"
        priority                   = 700
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        destination_port_range     = "*"
        source_address_prefix      = "*"
      } 
    ]
  }
}

# ===================================================================
# VM Variables
# ===================================================================

ip_config_name              = "internal"
ip_address_allocation       = "Static"


Front_vm_name               = "Front-VM"
Front_private_ip_address    = "10.0.0.5"


Back_vm_name                = "Back-VM"
Back_private_ip_address     = "10.0.1.5"


DB_vm_name                  = "DB-VM"
DB_private_ip_address       = "10.0.2.5"


//App_VM_Size                 = "Standard_F8s_v2"
App_VM_Size                 = "Standard_B2s_v2"
App_Disk_Size               = "500"

//DB_VM_Size                  = "Standard_F16s_v2"
DB_VM_Size                  = "Standard_B2s_v2"
DB_Disk_Size                = "1024"

storage_account_type        = "StandardSSD_LRS"
vm_caching                  = "ReadWrite"

admin_username              = "adminuser"

UbuntuServer =   {
  publisher   =   "canonical"
  offer       =   "0001-com-ubuntu-server-jammy"
  sku         =   "22_04-lts-gen2"
  version     =   "latest"
}

# ===================================================================
# AppGW&WAF
# ===================================================================

appgw_name  = "DH-AppGW"
waf_name    = "DH-WAF"

