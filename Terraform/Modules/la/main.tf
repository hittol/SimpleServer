# ===================================================================
# Create Log Analytics Workspace
# ===================================================================

resource "azurerm_log_analytics_workspace" "linux-vm-log" {
  name                = var.la_name
  location            = var.location
  resource_group_name = var.Hub_rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# ===================================================================
# Create Data Collection Rule
# ===================================================================

resource "azurerm_monitor_data_collection_rule" "linux-vm-dcr" {
  name                = var.dcr_name
  location            = var.location
  resource_group_name = var.Hub_rg_name

  destinations {
    log_analytics {
      name                  = "LinuxVM-Destination-Log"
      workspace_resource_id = azurerm_log_analytics_workspace.linux-vm-log.id
    }
  }

  data_sources {
    syslog {
      name           = "syslog-all"
      facility_names = ["*"]
      log_levels     = ["Warning", "Error", "Critical", "Alert", "Emergency"]
      streams        = ["Microsoft-Syslog"]
    }

    # performance_counter {
    #   name                           = "linux-perf-basic"
    #   streams                        = ["Microsoft-Perf"]
    #   sampling_frequency_in_seconds  = 60
    #   counter_specifiers             = [
    #     "Processor(*)/% Processor Time",
    #     "Memory(*)/Available MBytes",
    #     "Logical Disk(*)/Free Megabytes"
    #   ]
    # }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["LinuxVM-Destination-Log"]
  }
}

# ===================================================================
# DCR Association VM
# ===================================================================

resource "azurerm_monitor_data_collection_rule_association" "FrontVM" {
  name                        = "FrontVM-DCR-Association"
  target_resource_id          = var.frontvm_id
  data_collection_rule_id     = azurerm_monitor_data_collection_rule.linux-vm-dcr.id
}

resource "azurerm_monitor_data_collection_rule_association" "BackVM" {
  name                        = "BackVM-DCR-Association"
  target_resource_id          = var.backvm-01_id
  data_collection_rule_id     = azurerm_monitor_data_collection_rule.linux-vm-dcr.id
}

resource "azurerm_monitor_data_collection_rule_association" "DBVM-01" {
  name                        = "DBVM-DCR-Association"
  target_resource_id          = var.dbvm-01_id
  data_collection_rule_id     = azurerm_monitor_data_collection_rule.linux-vm-dcr.id
}