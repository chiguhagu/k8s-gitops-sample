output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.this.kube_config.0.client_certificate}"
}

output "kube_config_raw" {
  value = "${azurerm_kubernetes_cluster.this.kube_config_raw}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.this.kube_config}"
}

output "name" {
  value = "${azurerm_kubernetes_cluster.this.name}"
}

