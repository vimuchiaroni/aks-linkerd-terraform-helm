resource "tls_private_key" "trustanchor_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
  count       = var.enable_linkerd == true ? 1 : 0
}

resource "tls_self_signed_cert" "trustanchor_cert" {
  key_algorithm         = tls_private_key.trustanchor_key[count.index].algorithm
  private_key_pem       = tls_private_key.trustanchor_key[count.index].private_key_pem
  validity_period_hours = 87600
  is_ca_certificate     = true

  subject {
    common_name = "identity.linkerd.cluster.local"
  }

  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
  count = var.enable_linkerd == true ? 1 : 0
}

resource "tls_private_key" "issuer_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
  count       = var.enable_linkerd == true ? 1 : 0
}

resource "tls_cert_request" "issuer_req" {
  key_algorithm   = tls_private_key.issuer_key[count.index].algorithm
  private_key_pem = tls_private_key.issuer_key[count.index].private_key_pem

  subject {
    common_name = "identity.linkerd.cluster.local"
  }
  count = var.enable_linkerd == true ? 1 : 0
}

resource "tls_locally_signed_cert" "issuer_cert" {
  cert_request_pem      = tls_cert_request.issuer_req[count.index].cert_request_pem
  ca_key_algorithm      = tls_private_key.trustanchor_key[count.index].algorithm
  ca_private_key_pem    = tls_private_key.trustanchor_key[count.index].private_key_pem
  ca_cert_pem           = tls_self_signed_cert.trustanchor_cert[count.index].cert_pem
  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
  count = var.enable_linkerd == true ? 1 : 0
}


resource "azurerm_kubernetes_cluster_node_pool" "infra_nodepool" {
  name                  = var.poolmachine_name_infra_nodepool
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8scluster.id
  vm_size               = var.vm_family_infra_nodepool
  node_count            = var.enable_autoscaling_infra_pool == false ? var.infra_replica_count : null
  max_pods              = var.max_pods
  os_disk_size_gb       = var.os_disk_size_gb
  os_type               = "Linux"
  node_taints           = ["dedicated=infra:NoSchedule"]
  vnet_subnet_id        = var.vnet_subnet_id != "" ? var.vnet_subnet_id : azurerm_subnet.subnet.0.id
  availability_zones    = var.availability_zones

  enable_auto_scaling = var.enable_autoscaling_infra_pool
  max_count           = var.enable_autoscaling_infra_pool == true ? var.autoscaling_infra_pool_max_count : null
  min_count           = var.enable_autoscaling_infra_pool == true ? var.autoscaling_infra_pool_min_count : null

  tags  = var.tags
  count = var.enable_linkerd == true && var.linkerd_ha == true ? 1 : 0
}


resource "helm_release" "linkerd_dev" {
  name       = "linkerd"
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd2"
  version    = var.linkerd_chart_version
  depends_on = [
    azurerm_kubernetes_cluster.k8scluster
  ]

  set {
    name  = "proxy.resources.cpu.request"
    value = var.linkerd_proxy_cpu_requests

  }
  set {
    name  = "identityTrustAnchorsPEM"
    value = tls_self_signed_cert.trustanchor_cert[count.index].cert_pem
  }

  set {
    name  = "identity.issuer.crtExpiry"
    value = tls_locally_signed_cert.issuer_cert[count.index].validity_end_time
  }

  set {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_locally_signed_cert.issuer_cert[count.index].cert_pem
  }

  set {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.issuer_key[count.index].private_key_pem
  }
  count = var.enable_linkerd == true && var.linkerd_ha == false ? 1 : 0
}

resource "helm_release" "linkerd_ha" {
  name       = "linkerd"
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd2"
  version    = var.linkerd_chart_version
  depends_on = [
    azurerm_kubernetes_cluster.k8scluster,
    azurerm_kubernetes_cluster_node_pool.infra_nodepool
  ]
  set {
    name  = "proxy.resources.cpu.request"
    value = var.linkerd_proxy_cpu_requests

  }
  set {
    name  = "proxy.resources.memory.request"
    value = var.linkerd_proxy_memory_request

  }
  set {
    name  = "proxy.resources.memory.limit"
    value = var.linkerd_proxy_memory_limit

  }
  set {
    name  = "controllerResources.cpu.request"
    value = var.linkerd_controller_resources_cpu_request
  }
  set {
    name  = "controllerResources.memory.limit"
    value = var.linkerd_controller_resources_memory_limit
  }
  set {
    name  = "controllerResources.memory.request"
    value = var.linkerd_controller_resources_memory_request
  }
  set {
    name  = "destinationResources.cpu.request"
    value = var.linkerd_controller_resources_cpu_request
  }
  set {
    name  = "destinationResources.memory.limit"
    value = var.linkerd_controller_resources_memory_limit
  }

  set {
    name  = "destinationResources.memory.request"
    value = var.linkerd_controller_resources_memory_request
  }
  set {
    name  = "identityResources.cpu.request"
    value = var.linkerd_controller_resources_cpu_request
  }
  set {
    name  = "identityResources.memory.limit"
    value = var.linkerd_controller_resources_memory_limit
  }
  set {
    name  = "identityResources.memory.request"
    value = var.linkerd_identity_resources_memory_request
  }
  set {
    name  = "heartbeatResources.cpu.request"
    value = var.linkerd_controller_resources_cpu_request
  }
  set {
    name  = "heartbeatResources.memory.limit"
    value = var.linkerd_controller_resources_memory_limit
  }
  set {
    name  = "heartbeatResources.memory.request"
    value = var.linkerd_controller_resources_memory_request
  }
  set {
    name  = "proxyInjectorResources.cpu.request"
    value = var.linkerd_controller_resources_cpu_request
  }
  set {
    name  = "proxyInjectorResources.memory.limit"
    value = var.linkerd_controller_resources_memory_limit
  }
  set {
    name  = "proxyInjectorResources.memory.request"
    value = var.linkerd_controller_resources_memory_request
  }
  set {
    name  = "spValidatorResources.cpu.request"
    value = var.linkerd_controller_resources_cpu_request
  }
  set {
    name  = "spValidatorResources.memory.limit"
    value = var.linkerd_controller_resources_memory_limit
  }
  set {
    name  = "spValidatorResources.memory.request"
    value = var.linkerd_controller_resources_memory_request
  }
  set {
    name  = "webhookFailurePolicy"
    value = "Fail"
  }
  set {
    name  = "enablePodAntiAffinity"
    value = "true"
  }
  set {
    name  = "controllerReplicas"
    value = var.linkerd_controller_replicas
  }
  set {
    name  = "nodeSelector.agentpool"
    value = var.poolmachine_name_infra_nodepool
  }
  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }
  set {
    name  = "tolerations[0].key"
    value = "dedicated"
  }
  set {
    name  = "tolerations[0].value"
    value = "infra"
  }
  set {
    name  = "controller.tolerations[0].operator"
    value = "Equal"
  }
  set {
    name  = "identityTrustAnchorsPEM"
    value = tls_self_signed_cert.trustanchor_cert[count.index].cert_pem
  }
  set {
    name  = "identity.issuer.crtExpiry"
    value = tls_locally_signed_cert.issuer_cert[count.index].validity_end_time
  }
  set {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_locally_signed_cert.issuer_cert[count.index].cert_pem
  }
  set {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.issuer_key[count.index].private_key_pem
  }
  count = var.enable_linkerd == true && var.linkerd_ha == true ? 1 : 0
}