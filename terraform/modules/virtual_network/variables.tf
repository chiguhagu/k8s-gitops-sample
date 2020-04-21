variable "name" {
  default = "akstemplate"
}

variable "resource_group_name" {
}

variable "address_space" {
  type    = list(string)
  default = ["15.0.0.0/8"]
}

variable "location" {
  default = "japaneast"
}

variable "environment" {
  default = "Development"
}
