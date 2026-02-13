resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
    labels = {
      "istio-injection" = "enabled"
    }
  }
  depends_on = [null_resource.wait_for_cluster]
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    name = "istio-ingress"
    labels = {
      "istio-injection" = "enabled"
    }
  }
  depends_on = [kubernetes_namespace.istio_system]
}

resource "helm_release" "istio_base" {
  count      = var.enable_istio ? 1 : 0
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = var.istio_version
  namespace  = kubernetes_namespace.istio_system.metadata[0].name

  set {
    name  = "defaultRevision"
    value = "default"
  }

  depends_on = [kubernetes_namespace.istio_system]
}

resource "helm_release" "istiod" {
  count      = var.enable_istio ? 1 : 0
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = var.istio_version
  namespace  = kubernetes_namespace.istio_system.metadata[0].name

  set {
    name  = "meshConfig.enableAutoMTLS"
    value = "true"
  }

  set {
    name  = "meshConfig.ingressSelector"
    value = "istio=ingressgateway"
  }

  depends_on = [helm_release.istio_base[0]]
}

resource "helm_release" "istio_ingress" {
  count      = var.enable_istio ? 1 : 0
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = var.istio_version
  namespace  = kubernetes_namespace.istio_ingress.metadata[0].name

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "labels.istio"
    value = "ingressgateway"
  }

  depends_on = [helm_release.istiod[0]]
}

resource "kubernetes_network_policy" "istio_policy" {
  metadata {
    name      = "istio-policy"
    namespace = kubernetes_namespace.istio_system.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {
        "app" = "istio"
      }
    }

    policy_types = ["Ingress", "Egress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            "name" = kubernetes_namespace.istio_system.metadata[0].name
          }
        }
      }
    }

    egress {
      to {
        namespace_selector {}
      }
      ports {
        protocol = "TCP"
        port     = "443"
      }
    }
  }

  depends_on = [helm_release.istio_ingress[0]]
}