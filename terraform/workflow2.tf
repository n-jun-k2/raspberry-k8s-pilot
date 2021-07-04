resource "kubernetes_pod" "test2" {
  metadata {
    name = "terraform-example"
    namespace = "${var.work-space-name}"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"
      tty = true

      port {
        container_port = 8080
      }

      liveness_probe {
        http_get {
          path = "/nginx_status"
          port = 80

          http_header {
            name  = "X-Custom-Header"
            value = "Awesome"
          }
        }

        initial_delay_seconds = 3
        period_seconds        = 3
      }
    }
  }
}
