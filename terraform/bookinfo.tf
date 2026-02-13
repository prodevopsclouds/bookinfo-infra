provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "bookinfo" {
  metadata {
    name = "bookinfo"
  }
}

resource "kubernetes_service" "productpage" {
  metadata {
    name      = "productpage"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    selector = {
      app = "productpage"
    }
    port {
      port     = 9080
      target_port = 9080
    }
  }
}

resource "kubernetes_service" "details" {
  metadata {
    name      = "details"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    selector = {
      app = "details"
    }
    port {
      port     = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_service" "reviews" {
  metadata {
    name      = "reviews"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    selector = {
      app = "reviews"
    }
    port {
      port     = 9080
      target_port = 9080
    }
  }
}

resource "kubernetes_service" "ratings" {
  metadata {
    name      = "ratings"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    selector = {
      app = "ratings"
    }
    port {
      port     = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_deployment" "productpage" {
  metadata {
    name      = "productpage"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "productpage"
      }
    }
    template {
      metadata {
        labels = {
          app = "productpage"
        }
      }
      spec {
        container {
          name  = "productpage"
          image = "istio/examples-bookinfo-productpage-v1:latest"
          ports {
            container_port = 9080
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "details" {
  metadata {
    name      = "details"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "details"
      }
    }
    template {
      metadata {
        labels = {
          app = "details"
        }
      }
      spec {
        container {
          name  = "details"
          image = "istio/examples-bookinfo-details-v1:latest"
          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "reviews" {
  metadata {
    name      = "reviews"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "reviews"
      }
    }
    template {
      metadata {
        labels = {
          app = "reviews"
        }
      }
      spec {
        container {
          name  = "reviews"
          image = "istio/examples-bookinfo-reviews-v1:latest"
          ports {
            container_port = 9080
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "ratings" {
  metadata {
    name      = "ratings"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "ratings"
      }
    }
    template {
      metadata {
        labels = {
          app = "ratings"
        }
      }
      spec {
        container {
          name  = "ratings"
          image = "istio/examples-bookinfo-ratings-v1:latest"
          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "bookinfo" {
  metadata {
    name      = "bookinfo"
    namespace = kubernetes_namespace.bookinfo.metadata[0].name
  }
  spec {
    backend {
      service_name = kubernetes_service.productpage.metadata[0].name
      service_port = 9080
    }
  }
}