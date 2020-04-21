resource "random_id" "this" {
  byte_length = 3
}

resource "azurerm_storage_account" "this" {
  name                      = "${var.name}${random_id.this.hex}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"
  account_tier              = "${var.tier}"
  account_kind              = "${var.kind}"
  account_replication_type  = "${var.replication_type}"
  access_tier               = "${var.access_tier}"

  network_rules {
    default_action = "${var.enable_network_rule}"
    bypass = [
      "Logging",
      "Metrics",
      "AzureServices",
    ]
  }

  tags = {
    environment = "${var.environment}"
  }
}