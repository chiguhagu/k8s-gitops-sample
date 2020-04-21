resource "azurerm_subnet" "this" {
  name                      = "subnet_${var.name}"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${var.virtual_network_name}"
  address_prefix            = "${var.address_prefix}"
  # # Pending
  # lifecycle {
  #   ignore_changes = [
  #     "network_security_group_id",
  #   ]
  # }
}
