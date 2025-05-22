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