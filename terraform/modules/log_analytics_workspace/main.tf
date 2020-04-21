resource "random_id" "this" {
  byte_length = 3
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.name}${random_id.this.hex}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  sku                 = "PerGB2018"

  tags = {
    Environment = "${var.environment}"
  }
}