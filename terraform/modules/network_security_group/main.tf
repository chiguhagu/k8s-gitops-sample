resource "random_id" "this" {
  byte_length = 3
}

resource "azurerm_network_security_group" "this" {
  name                = "${var.name}${random_id.this.hex}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "network_security_group_diagnostic${random_id.this.hex}"
  target_resource_id         = "${azurerm_network_security_group.this.id}"
  storage_account_id         = "${var.storage_account_id}"
  log_analytics_workspace_id = "${var.log_analytics_workspace_id}"

  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}