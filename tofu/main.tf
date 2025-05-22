# =============================
# 3. OpenTofu Infra
# =============================
# tofu/main.tf
resource "kubernetes_namespace" "infra" {
  metadata {
    name = "infra"
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  }
}


resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = "monitoring"
  create_namespace = true

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "51.2.0" # ou outra versão compatível

  values = [
    file("${path.module}/values/prometheus-values.yaml")
  ]
}


resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = "monitoring"

  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "7.3.7" # ou outra versão desejada

  values = [
    file("${path.module}/values/grafana-values.yaml")
  ]
}