# Kubernetes Deployment Manifest
resource "kubernetes_deployment_v1" "myapp1" {
  metadata {
    name = "myapp1-deployment"
    labels = {
      app = "var.app_name"
    }
  } 
 
  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "var.app_name"
      }
    }

    template {
      metadata {
        labels = {
          app = "var.app_name"
        }
      }

      spec {
        container {
          image = "stacksimplify/kubenginx:1.0.0"
          name  = "myapp1-container"
          port {
            container_port = 80
          }
          }
        }
      }
    }
}