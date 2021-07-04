
resource "kubernetes_namespace" "example" {
  metadata {
    name = "${var.work-space-name}"
  }
}
