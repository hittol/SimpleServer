terraform {
  required_providers {  
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.36"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}