variable "name" {
  default = "akstemplate"
}

variable "resource_group_name" {
}

variable "location" {
  default = "japaneast"
}

variable "tier" {
  default = "Standard"
}

variable "replication_type" {
  default = "LRS"
}

variable "environment" {
  default = "Development"
}

variable "kind" {
  default = "StorageV2"
}

variable "access_tier" {
  default = "Hot"
}

variable "enable_network_rule" {
  default = "Allow"
}
