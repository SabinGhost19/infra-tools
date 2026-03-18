terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.2"
    }
  }
}

locals {
  vault_addr           = "http://vault.vault.svc.cluster.local:8200"
  vault_token          = "root"
  secret_mount_path    = "secret"
  kubernetes_auth_path = "kubernetes"
}

provider "vault" {
  address = local.vault_addr
  token   = local.vault_token
}

resource "vault_policy" "demo_api_policy" {
  name   = "demo-api-policy"
  policy = <<-EOT
path "secret/data/prod/demo-api/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_config" "config" {
  backend                = local.kubernetes_auth_path
  kubernetes_host        = "https://kubernetes.default.svc"
  kubernetes_ca_cert     = file("/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
  disable_iss_validation = true
}

resource "vault_kubernetes_auth_backend_role" "demo_api_prod_role" {
  backend                          = local.kubernetes_auth_path
  role_name                        = "demo-api-prod-role"
  bound_service_account_names      = ["default", "external-secrets"]
  bound_service_account_namespaces = ["default", "external-secrets"]
  token_policies                   = [vault_policy.demo_api_policy.name]
  token_ttl                        = 3600
}

resource "vault_kv_secret_v2" "demo_api_config" {
  mount = local.secret_mount_path
  name  = "prod/demo-api/config"

  data_json = jsonencode({
    username = "demo_user"
    password = "demo_pass_v1"
  })
}
