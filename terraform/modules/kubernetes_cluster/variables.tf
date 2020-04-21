variable "name" {
  default = "akstemplate"
}

variable "location" {
  default = "japaneast"
}

variable "resource_group_name" {
}

variable "vnet_subnet_id" {
}

variable "environment" {
  default = "Development"
}

variable "sp_client_id" {
}

variable "sp_client_secret" {
}

variable "log_analytics_workspace_id" {
}

variable "storage_account_id" {
}
