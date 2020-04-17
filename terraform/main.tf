provider "azurerm" {
  version         = "=2.6.0"
  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
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

# provider "azuread" {
#   version = "=0.7.0"
# }

provider "random" {
  version = "=2.2.1"
}

resource "random_id" "rg" {
  byte_length = 3
}

resource "azurerm_resource_group" "this" {
  name     = "k8sgitops${random_id.rg.hex}"
  location = "japaneast"
  tags = {
    env = "tmp"
  }
}
