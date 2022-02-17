resource "azurerm_kubernetes_cluster" "k8scluster" {
  name                            = var.cluster_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  dns_prefix                      = var.dns_prefix
  kubernetes_version              = var.kubernetes_version
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges


  default_node_pool {
    name                = var.poolmachine_name_application
    node_count          = var.enable_autoscaling_app_pool == false ? var.agent_count : null
    vm_size             = var.vm_family
    max_pods            = var.max_pods
    os_disk_size_gb     = var.os_disk_size_gb
    vnet_subnet_id      = var.vnet_subnet_id
    enable_auto_scaling = var.enable_autoscaling_app_pool
    max_count           = var.enable_autoscaling_app_pool == true ? var.autoscaling_app_pool_max_count : null
    min_count           = var.enable_autoscaling_app_pool == true ? var.autoscaling_app_pool_min_count : null
    availability_zones  = var.availability_zones
  }

  addon_profile {
    http_application_routing {
      enabled = var.enable_http_application_routing
    }
    azure_policy {
      enabled = var.enable_azure_policy
    }
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  network_profile {
    network_plugin     = "azure"
    docker_bridge_cidr = var.docker_bridge_cidr
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    load_balancer_sku  = var.load_balancer_sku
  }

  role_based_access_control {
    enabled = var.rbac
  }

  tags       = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "nginx_nodepool" {
  name                  = var.poolmachine_name_nginx_ingress
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8scluster.id
  vm_size               = var.vm_family_nginx_ingress
  node_count            = var.enable_autoscaling_nginx_pool == false ? var.replica_count : null
  max_pods              = var.max_pods
  os_disk_size_gb       = var.os_disk_size_gb
  os_type               = "Linux"
  node_taints           = ["dedicated=nginx-ingress:NoSchedule"]
  vnet_subnet_id        = var.vnet_subnet_id
  availability_zones    = var.availability_zones

  enable_auto_scaling = var.enable_autoscaling_nginx_pool
  max_count           = var.enable_autoscaling_nginx_pool == true ? var.autoscaling_nginx_pool_max_count : null
  min_count           = var.enable_autoscaling_nginx_pool == true ? var.autoscaling_nginx_pool_min_count : null

  tags = var.tags
  lifecycle {
    ignore_changes = [
      # See https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#tags-1
      # and https://www.terraform.io/docs/configuration/resources.html#ignore_changes
      tags,
    ]
  }
}

# kube config and helm init
resource "local_file" "kube_config" {
  # kube config
  filename = var.k8s_kube_config
  content  = azurerm_kubernetes_cluster.k8scluster.kube_config_raw

  # helm init
  # provisioner "local-exec" {
  #     command = "helm init --history-max=$TILLER_MAX_HISTORY --client-only"
  #     #command = "helm init --override \"spec.selector.matchLabels.agentpool\"=\"poolapp\" --history-max=$TILLER_MAX_HISTORY --client-only"
  #     environment = {
  #         KUBECONFIG         = var.k8s_kube_config
  #         HELM_HOME          = var.k8s_helm_home
  #         TILLER_MAX_HISTORY = var.tiller_max_history
  #     }
  # }
  depends_on = [azurerm_kubernetes_cluster.k8scluster]
}



