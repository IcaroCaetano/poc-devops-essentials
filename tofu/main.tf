resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "springboot" {
  name       = "springboot-app"
  chart      = "${path.module}/../helm/springboot-chart"
  namespace  = kubernetes_namespace.app_namespace.metadata[0].name
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]
}
