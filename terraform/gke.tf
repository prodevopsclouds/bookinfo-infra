resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.cluster_zone
  initial_node_count       = var.num_nodes
  remove_default_node_pool = true
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 10
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 1
      maximum       = 64
    }
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  workload_identity_config {
    workload_pool = "${var.gcp_project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.cluster_zone
  cluster    = google_container_cluster.primary.name
  node_count = var.num_nodes

  autoscaling {
    min_node_count = 2
    max_node_count = 10
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = var.machine_type
    disk_size_gb = 50

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env      = "production"
      app      = "bookinfo"
      managed  = "terraform"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

resource "null_resource" "wait_for_cluster" {
  depends_on = [google_container_node_pool.primary_nodes]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}