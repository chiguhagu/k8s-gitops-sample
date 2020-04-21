provider "azurerm" {
  version         = "=2.6.0"
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true # (Optional) Should the azurerm_key_vault resource recover a Key Vault which has previously been Soft Deleted? Defaults to true.
      purge_soft_delete_on_destroy    = true # (Optional) Should the azurerm_key_vault resource be permanently deleted (e.g. purged) when destroyed? Defaults to true.
    }
    virtual_machine {
      delete_os_disk_on_deletion = true # (Optional) Should the azurerm_linux_virtual_machine and azurerm_windows_virtual_machine resources delete the OS Disk attached to the Virtual Machine when the Virtual Machine is destroyed? Defaults to true.
    }
    virtual_machine_scale_set {
      roll_instances_when_required = true # (Optional) Should the azurerm_linux_virtual_machine_scale_set and azurerm_windows_virtual_machine_scale_set resources automatically roll the instances in the Scale Set when Required (for example when updating the Sku/Image). Defaults to true.
    }
  }
}

terraform {
  backend "azurerm" {}
}

provider "azuread" {
  version = "=0.7.0"
}

provider "random" {
  version = "=2.2.1"
}

module "mo_resource_group_all" {
  source = "../modules/resource_group"

  name        = "${var.prefix}-all"
  location    = "${var.primary_location}"
  environment = "${var.environment}"
}

# Logging Resources

module "mo_log_analytics_workspace_logs" {
  source = "../modules/log_analytics_workspace"

  name                = "${var.prefix}log"
  resource_group_name = "${module.mo_resource_group_all.name}"
  location            = "${module.mo_resource_group_all.location}"
  environment         = "${var.environment}"
}

module "mo_storage_account_logs" {
  source = "../modules/storage_account"
  
  name                = "${var.prefix}log"
  resource_group_name = "${module.mo_resource_group_all.name}"
  location            = "${module.mo_resource_group_all.location}"
  tier                = "Standard"
  replication_type    = "GRS"
  environment         = "Development"
  kind                = "StorageV2"
  access_tier         = "Hot"
  enable_network_rule = "Allow"
}

# AKS Resources

module "mo_virtual_network_all" {
  source = "../modules/virtual_network"

  name                        = "${var.prefix}all"
  resource_group_name         = "${module.mo_resource_group_all.name}"
  location                    = "${module.mo_resource_group_all.location}"
  environment                 = "${var.environment}"
  address_space               = ["15.0.0.0/8"]
}

module "mo_subnet_aks" {
  source = "../modules/subnet"
  
  name                  = "15.1.0.0_16"
  address_prefix        = "15.1.0.0/16"
  resource_group_name   = "${module.mo_resource_group_all.name}"
  virtual_network_name  = "${module.mo_virtual_network_all.name}"
}

module "mo_nsg_aks" {
  source = "../modules/network_security_group"

  name                        = "${var.prefix}aks"
  location                    = "${module.mo_resource_group_all.location}"
  resource_group_name         = "${module.mo_resource_group_all.name}"
  environment                 = "${var.environment}"
  storage_account_id          = "${module.mo_storage_account_logs.id}"
  log_analytics_workspace_id  = "${module.mo_log_analytics_workspace_logs.id}"
}

module "mo_kubernetes_cluster_aks" {
  source = "../modules/kubernetes_cluster"
  
  name                = "${var.prefix}aks"
  location            = "${module.mo_resource_group_all.location}"
  resource_group_name = "${module.mo_resource_group_all.name}"
  environment         = "${var.environment}"

  vnet_subnet_id              = "${module.mo_subnet_aks.id}"
  sp_client_id                = "${var.sp_client_id}"
  sp_client_secret            = "${var.sp_client_secret}"
  log_analytics_workspace_id  = "${module.mo_log_analytics_workspace_logs.id}"
  storage_account_id          = "${module.mo_storage_account_logs.id}"
}
