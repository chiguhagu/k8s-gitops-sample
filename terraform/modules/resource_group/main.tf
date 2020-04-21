resource "random_id" "this" {
  byte_length = 3
}

resource "azurerm_resource_group" "this" {
  name     = "${var.name}${random_id.this.hex}"
  location = "${var.location}"

  tags = {
    environment = "${var.environment}"
  }
}
