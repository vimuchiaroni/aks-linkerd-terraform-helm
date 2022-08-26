provider "azurerm" {
  version = "~> 2.90.0"
  features {}
  skip_provider_registration = true
}


provider "kubernetes" {
  version = "~> 2.8"
  # #  load_config_file       = false
  #   host                   = "${data.azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.host}"
  #   client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.client_certificate)}"
  #   client_key             = "${base64decode(data.azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.client_key)}"
  #   cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.cluster_ca_certificate)}"
  config_path = local_file.kube_config.filename
}

provider "helm" {
  debug   = true
  version = "~> 2.4.0"
  kubernetes {
    # host                   = "${data.azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.host}"
    # client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.client_certificate)}"
    # client_key             = "${base64decode(data.azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.client_key)}"
    # cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.cluster_ca_certificate)}"
    config_path = local_file.kube_config.filename
  }
}

provider "local" {
  version = "~> 1.4"
}

provider "null" {
  version = "~> 2.1"
}

provider "tls" {
  version = "3.4.0"
}
