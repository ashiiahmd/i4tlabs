output "kubernetes_api_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "nginx_external_ip" {
  value = kubernetes_service.nginx_service.load_balancer_ingress[0].ip
}
