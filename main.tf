provider "google" {
  credentials = file("<PATH_TO_YOUR_GCP_SERVICE_ACCOUNT_JSON>")
  project     = var.gcp_project_id
  region      = "us-central1"  # You can change the region if needed
}

resource "google_project" "project" {
  name            = var.gcp_project_id
  project_id      = var.gcp_project_id
  org_id          = "<YOUR_ORG_ID>"
  auto_create_network = true
}

resource "google_container_cluster" "gke_cluster" {
  name     = var.gke_cluster_name
  location = "us-central1-a"  # You can change the zone if needed
  project  = google_project.project.project_id
}

resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name = "nginx-deployment"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      protocol = "TCP"
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
