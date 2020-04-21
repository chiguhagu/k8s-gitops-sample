resource "random_id" "this" {
  byte_length = 3
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.name}${random_id.this.hex}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.name}dns${random_id.this.hex}"

  default_node_pool {
    name                  = "default"
    vm_size               = "Standard_D1_v2"
    availability_zones    = ["1", "2", "3"]
    enable_auto_scaling   = false
    node_count            = 3

    # if "enable_auto_scaling" is true
    # need "max_count" and "min_count"

    enable_node_public_ip = false
    max_pods              = 250 # 250 is MAX pods

    # node_taints (Don't use because this env is verification)
    # os_disk_size_gb (Don't use, but don't have reason)

    type                  = "VirtualMachineScaleSets"
    vnet_subnet_id        = "${var.vnet_subnet_id}"    
  }

  service_principal {
    client_id     = "${var.sp_client_id}"
    client_secret = "${var.sp_client_secret}"
  }

  addon_profile {
    # aci_connector_linux (Don't use)

    # azure_policy (Preview)

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = true
    }

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "${var.log_analytics_workspace_id}"
    }
  }

  # These sections is preview
  # api_server_authorized_ip_ranges {}
  # enable_pod_security_policy {}

  kubernetes_version = "1.16.7"

  # # I don't want to use this section
  # linux_profile {}

  network_profile {
    network_plugin      = "azure"

    # This type is Preview
    # network_policy

    # # Options?
    # dns_service_ip      = "10.0.0.10"
    # docker_bridge_cidr  = "172.17.0.1/16"
    # service_cidr        = "10.0.0.0/16"
    load_balancer_sku   = "Standard"

    # # If network_plugin is kubenet, must use this type
    # pods_cidr
  }

  # # Try to delete this section
  # agent_pool_profile {
  #   name            = "default"
  #   count           = "${var.vm_count}"
  #   vm_size         = "${var.vm_size}"
  #   os_type         = "Linux"
  #   os_disk_size_gb = 30
  #   type            = "AvailabilitySet"
  #   vnet_subnet_id  = "${var.vnet_subnet_id}"
  #   max_pods        = "${var.max_pods}"
  # }

  node_resource_group = "${var.name}nodes${random_id.this.hex}"

  role_based_access_control {
    # # This section is pending
    # azure_active_directory {
    #   client_app_id = ""
    #   server_app_id = ""
    #   server_app_secret = ""
    #   tenant_id = ""
    # }
    enabled = true
  }

  tags = {
    Environment = "${var.environment}"
  }

  # # This section is pending
  # lifecycle {
  #   ignore_changes = [
  #     "addon_profile",
  #     "service_principal",
  #   ]
  # }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "kubernetes_cluster_diagnostic"
  target_resource_id         = "${azurerm_kubernetes_cluster.this.id}"
  storage_account_id         = "${var.storage_account_id}"
  log_analytics_workspace_id = "${var.log_analytics_workspace_id}"

  log {
    category = "kube-apiserver"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-scheduler"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}
