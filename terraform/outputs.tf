output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
  sensitive   = true
}

output "region" {
  value       = var.gcp_region
  description = "GCP region"
}

output "project_id" {
  value       = var.gcp_project_id
  description = "GCP Project ID"
}

output "kubectl_config_command" {
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone ${var.cluster_zone} --project ${var.gcp_project_id}"
  description = "Command to configure kubectl"
}