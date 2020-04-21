resource "random_id" "this" {
  byte_length = 3
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.name}${random_id.this.hex}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  address_space       = "${var.address_space}"

  tags = {
    environment = "${var.environment}"
  }
}
