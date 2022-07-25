# Kubernetes Deployment Manifest
resource "kubernetes_deployment_v1" "myapp1" {
  metadata {
    name = "myapp1-deployment"
    labels = {
      app = "var.name_app"
    }
  } 
 
  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "var.name_app"
      }
    }

    template {
      metadata {
        labels = {
          app = "var.name_app"
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