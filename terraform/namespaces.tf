# Crea los tres namespaces en AKS después de que el cluster esté listo.
# Usa local-exec para no necesitar el provider de Kubernetes en Terraform.

resource "null_resource" "k8s_namespaces" {
  depends_on = [azurerm_kubernetes_cluster.aks]

  provisioner "local-exec" {
    command = <<-EOT
      az aks get-credentials \
        --resource-group ${azurerm_resource_group.rg.name} \
        --name           ${azurerm_kubernetes_cluster.aks.name} \
        --overwrite-existing

      for NS in circleguard-dev circleguard-stage circleguard-prod; do
        kubectl create namespace $NS --dry-run=client -o yaml | kubectl apply -f -
      done
    EOT
  }
}
