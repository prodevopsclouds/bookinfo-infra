resource "kubernetes_namespace" "bookinfo" {
  metadata {
    name = var.bookinfo_namespace
    labels = {
      "istio-injection" = "enabled"
    }
  }
  depends_on = [helm_release.istiod[0]]
}

# Productpage Service
resource "kubernetes_service" "productpage" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "productpage"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
    labels = {
      app = "productpage"
    }
  }
  spec {
    selector = {
      app = "productpage"
    }
    port {
      protocol = "TCP"
      port     = 9080
      name     = "http"
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_namespace.bookinfo]
}

# Details Service
resource "kubernetes_service" "details" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "details"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
    labels = {
      app = "details"
    }
  }
  spec {
    selector = {
      app = "details"
    }
    port {
      protocol = "TCP"
      port     = 9080
      name     = "http"
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_namespace.bookinfo]
}

# Reviews Service
resource "kubernetes_service" "reviews" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "reviews"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
    labels = {
      app = "reviews"
    }
  }
  spec {
    selector = {
      app = "reviews"
    }
    port {
      protocol = "TCP"
      port     = 9080
      name     = "http"
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_namespace.bookinfo]
}

# Ratings Service
resource "kubernetes_service" "ratings" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "ratings"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
    labels = {
      app = "ratings"
    }
  }
  spec {
    selector = {
      app = "ratings"
    }
    port {
      protocol = "TCP"
      port     = 9080
      name     = "http"
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_namespace.bookinfo]
}

# Productpage Deployment
resource "kubernetes_deployment" "productpage_v1" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "productpage-v1"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app     = "productpage"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "productpage"
          version = "v1"
        }
      }
      spec {
        container {
          image = "docker.io/istio/examples-bookinfo-productpage-v1:1.18.0"
          name  = "productpage"
          port {
            container_port = 9080
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.bookinfo]
}

# Details Deployment
resource "kubernetes_deployment" "details_v1" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "details-v1"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app     = "details"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "details"
          version = "v1"
        }
      }
      spec {
        container {
          image = "docker.io/istio/examples-bookinfo-details-v1:1.18.0"
          name  = "details"
          port {
            container_port = 9080
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.bookinfo]
}

# Reviews V1 Deployment
resource "kubernetes_deployment" "reviews_v1" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "reviews-v1"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "reviews"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "reviews"
          version = "v1"
        }
      }
      spec {
        container {
          image = "docker.io/istio/examples-bookinfo-reviews-v1:1.18.0"
          name  = "reviews"
          port {
            container_port = 9080
          }
          env {
            name  = "LOG_DIR"
            value = "/tmp/logs"
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.bookinfo]
}

# Reviews V2 Deployment
resource "kubernetes_deployment" "reviews_v2" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "reviews-v2"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "reviews"
        version = "v2"
      }
    }
    template {
      metadata {
        labels = {
          app     = "reviews"
          version = "v2"
        }
      }
      spec {
        container {
          image = "docker.io/istio/examples-bookinfo-reviews-v2:1.18.0"
          name  = "reviews"
          port {
            container_port = 9080
          }
          env {
            name  = "LOG_DIR"
            value = "/tmp/logs"
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.bookinfo]
}

# Reviews V3 Deployment
resource "kubernetes_deployment" "reviews_v3" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "reviews-v3"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "reviews"
        version = "v3"
      }
    }
    template {
      metadata {
        labels = {
          app     = "reviews"
          version = "v3"
        }
      }
      spec {
        container {
          image = "docker.io/istio/examples-bookinfo-reviews-v3:1.18.0"
          name  = "reviews"
          port {
            container_port = 9080
          }
          env {
            name  = "LOG_DIR"
            value = "/tmp/logs"
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.bookinfo]
}

# Ratings Deployment
resource "kubernetes_deployment" "ratings_v1" {
  count = var.enable_bookinfo ? 1 : 0
  metadata {
    name      = "ratings-v1"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app     = "ratings"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "ratings"
          version = "v1"
        }
      }
      spec {
        container {
          image = "docker.io/istio/examples-bookinfo-ratings-v1:1.18.0"
          name  = "ratings"
          port {
            container_port = 9080
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.bookinfo]
}