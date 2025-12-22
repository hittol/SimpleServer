# ===================================================================
# Resource Group Variables
# ===================================================================

location = "koreacentral"

rg_setting = {
  "MainRG" = {
    name     = "RG-SimpleServer-Cloud"
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
      address_prefixes                = ["10.0.0.0/26"]
      nsg_key                         = "Front-nsg"
      default_outbound_access_enabled = true
    },
    "BackSubnet"                      = {
      address_prefixes                = ["10.0.0.64/26"]
      nsg_key                         = "Back-nsg"
      default_outbound_access_enabled = true
    },
    "StandbySubnet"                      = {
      address_prefixes                = ["10.0.0.128/26"]
      nsg_key                         = "Standby-nsg"
      default_outbound_access_enabled = true
    },  
    "DBSubnet"                        = {
      address_prefixes                = ["10.0.0.192/26"]
      nsg_key                         = "DB-nsg"
      default_outbound_access_enabled = false
    },
    "ApplicationGatewaySubnet"        = {
      address_prefixes                = ["10.0.1.0/24"]
      default_outbound_access_enabled = true
    }
}

nsg_rule    = {
  "Front-nsg" = {
    rules = [
      {
        name                        = "Allow_SSH_Inbound"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "22"
        source_address_prefix       = "1.1.1.1/32"
        destination_address_prefix  = "*"
      },
      {
        name                        = "Allow_AppGW_Http_Inbound"
        priority                    = 110
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "80"
        source_address_prefix       = "10.0.1.0/24"
        destination_address_prefix  = "*"
      },
      {
        name                        = "Allow_AppGW_Https_Inbound"
        priority                    = 120
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "10.0.1.0/24"
        destination_address_prefix  = "*"
      },
      {
        name                        = "Deny_All_Subnet_Inbound"
        priority                    = 1000
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "*"
        destination_port_range      = "*"
        source_address_prefix       = "10.0.0.64/26,10.0.0.128/26,10.0.0.192/26"
        destination_address_prefix  = "*"
      },
      {
        name                        = "Allow_To_LB_Outbound"
        priority                    = 100
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "80"
        source_address_prefix       = "*"
        destination_address_prefix  = "10.0.0.80/32"
      },
      {
        name                         = "Allow_To_Back_SSH_Outbound"
        priority                    = 110
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "10.0.0.64/26"

      },
      {
        name                        = "Allow_To_Standby_SSH_Outbound"
        priority                    = 120
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "10.0.0.128/26"
      },
      {
        name                        = "Allow_To_Monitor_Https_Outbound"
        priority                    = 130
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureMonitor"
      },
      {
        name                        = "Allow_To_Backup_Https_Outbound"
        priority                    = 140
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureBackup"
      },
      {
        name                        = "Allow_To_AD_Https_Outbound"
        priority                    = 140
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureActiveDirectory"
      },
      {
        name                        = "Allow_To_Storage_Https_Outbound"
        priority                    = 140
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "Storage"
      }
    ]
  },
  "Back-nsg" = {
    rules = [
      {
        name                        = "Allow_From_InternalLB_Inbound"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "80"
        source_address_prefix       = "*"
        destination_address_prefix  = "10.0.0.80/32"      
      },
      {
        name                        = "Allow_From_Front_SSH_Inbound"
        priority                    = 110
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "22"
        source_address_prefix       = "10.0.0.0/26"
        destination_address_prefix  = "*"
      },
      {
        name                        = "Deny_All_Subnet_Inbound"
        priority                    = 1000
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "*"
        destination_port_range      = "*"
        source_address_prefix       = "10.0.0.0/26,10.0.0.128/26,10.0.0.192/26"
        destination_address_prefix  = "*"
      },
      {
        name                        = "Allow_To_DB_SSH_Outbound"
        priority                    = 100
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "10.0.0.192/26"
      },
      {
        name                        = "Allow_To_Monitor_Https_Outbound"
        priority                    = 130
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureMonitor"
      },
      {
        name                        = "Allow_To_Backup_Https_Outbound"
        priority                    = 140
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureBackup"
      },
      {
        name                        = "Allow_To_AD_Https_Outbound"
        priority                    = 140
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureActiveDirectory"
      },
      {
        name                        = "Allow_To_Storage_Https_Outbound"
        priority                    = 140
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "Storage"
      }    
    ]
  },
  "Standby-nsg" = {
    rules = [
      {
        name                        = "Allow_From_InternalLB_Inbound"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "80"
        source_address_prefix       = "AzureLoadBalancer"
        destination_address_prefix  = "*"      
      },
      {
        name                        = "Allow_From_Front_SSH_Inbound"
        priority                    = 110
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "22"
        source_address_prefix       = "10.0.0.0/26"
        destination_address_prefix  = "*"
      },
      {
        name                        = "Deny_All_Subnet_Inbound"
        priority                    = 1000
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "*"
        destination_port_range      = "*"
        source_address_prefix       = "10.0.0.0/26,10.0.0.64/26,10.0.0.192/26"
        destination_address_prefix  = "*"
      },
      {
        name                        = "Allow_To_DB_SSH_Outbound"
        priority                    = 100
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "10.0.0.192/26"
      },
      {
        name                        = "Allow_To_Monitor_Https_Outbound"
        priority                    = 130
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureMonitor"
      },
      {
        name                        = "Allow_To_Backup_Https_Outbound"
        priority                    = 140
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureBackup"
      },
      {
        name                        = "Allow_To_AD_Https_Outbound"
        priority                    = 140
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureActiveDirectory"
      },
      {
        name                        = "Allow_To_Storage_Https_Outbound"
        priority                    = 140
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "Storage"
      }    
    ]
  },
  "DB-nsg" = {
    rules = [
      {
        name                        = "Allow_From_Back_Stnadby_SSH_Inbound"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "22"
        source_address_prefix       = "10.0.0.64/26,10.0.0.128/26"
        destination_address_prefix  = "*"      
      },
      {
        name                        = "Allow_From_Back_Stnadby_PostgreSQL_Inbound"
        priority                    = 110
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "5432"
        source_address_prefix       = "10.0.0.64/26,10.0.0.128/26"
        destination_address_prefix  = "*"
      },
      {
        name                        = "Deny_All_Subnet_Inbound"
        priority                    = 1000
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "*"
        destination_port_range      = "*"
        source_address_prefix       = "10.0.0.0/26,10.0.0.64/26,10.0.0.128/26"
        destination_address_prefix  = "*"
      },     
      {
        name                        = "Allow_To_Monitor_Https_Outbound"
        priority                    = 100
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureMonitor"
      },
      {
        name                        = "Allow_To_Backup_Https_Outbound"
        priority                    = 110
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureBackup"
      },
      {
        name                        = "Allow_To_AD_Https_Outbound"
        priority                    = 120
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "AzureActiveDirectory"
      },
      {
        name                        = "Allow_To_Storage_Https_Outbound"
        priority                    = 130
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        destination_port_range      = "443"
        source_address_prefix       = "*"
        destination_address_prefix  = "Storage"
      }  
    ]
  }
}

# ===================================================================
# VM Variables
# ===================================================================

ip_config_name              = "internal"
ip_address_allocation       = "Static"


Front_vm_name               = "VM-Front"
Front_private_ip_address    = "10.0.0.5"


Back_vm_name                = "VM-Back"
Back_private_ip_address     = "10.0.0.70"
Standby_vm_name             = "VM-Standby"
Standby_private_ip_address  = "10.0.0.140"

DB_vm_01_name               = "VM-DB-01"
DB_01_private_ip_address    = "10.0.0.200"
DB_vm_02_name               = "VM-DB-02"
DB_02_private_ip_address    = "10.0.0.201"
DB_vm_BU_name               = "VM-DB-Backup"
DB_BU_private_ip_address    = "10.0.0.202"


App_VM_Size                 = "Standard_B2s_v2"
App_Disk_Size               = "500"

DB_VM_Size                  = "Standard_B2s_v2"
DB_Disk_Size                = "1024"

DB_BU_VM_Size               = "Standard_B2s_v2"
DB_BU_Disk_Size             = "500"

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

appgw_name  = "SimpleServer-AppGW"
waf_name    = "SimpleServer-WAF"

# ===================================================================
# NATGW
# ===================================================================

natgw_name  = "SimpleServer-NATGW"

# ===================================================================
# Backup
# ===================================================================

rv_app_name       = "RV-SimpleServer-AppVM"
rv_db_name        = "RV-SimpleServer-DBVM"

backup_timezone   = "Korea Standard Time"
backup_frequency  = "Daily"
backup_time       = "23:00"

# ===================================================================
# log analytics
# ===================================================================

la_name   = "LogAnalytics-SimpleServer-VM"
dcr_name  = "DCR-SimpleServer-VM"

la_sku    = "PerGB2018"

# ===================================================================
# Load Balancer
# ===================================================================

lb_name               = "LB-SimpleServer"
lb_private_ip_address = "10.0.0.80"