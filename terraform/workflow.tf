resource "kubernetes_pod" "test" {
  metadata {
    name = "example-pods"
    namespace = "${var.work-space-name}"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name = "example"
      command = "${var.debug-command}"

      env {
        name = "environment"
        value = "test"
      }

      port {
        container_port = 8080
      }

      liveness_probe {
        http_get {
          path = "/nginx_status"
          port = 80

          http_header {
            name = "X-Custom-Header"
            value = "Awesome"
          }
        }

        initial_delay_seconds = 3
        period_seconds = 3

      }
    }

    dns_config {
      nameservers = ["1.1.1.1", "8.8.8.8", "9.9.9.9"]
      searches = ["example.com"]

      option {
        name = "hdots"
        value = 1
      }
    }

    restart_policy = "OnFailure"
    dns_policy = "None"
  }
}
