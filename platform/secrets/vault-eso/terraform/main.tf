terraform {
  required_version = ">= 1.6.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.2"
    }
  }
}

variable "vault_addr" { type = string }
variable "vault_token" {
  type      = string
  sensitive = true
}

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}

resource "vault_mount" "secret" {
  path = "secret"
  type = "kv-v2"
}

resource "vault_policy" "demo_api_policy" {
  name   = "demo-api-policy"
  policy = <<-EOT
path "secret/data/prod/demo-api/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "config" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://kubernetes.default.svc"
}

resource "vault_kubernetes_auth_backend_role" "demo_api_prod_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "demo-api-prod-role"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["default"]
  token_policies                   = [vault_policy.demo_api_policy.name]
  token_ttl                        = 3600
}

resource "vault_kv_secret_v2" "demo_api_config" {
  mount = vault_mount.secret.path
  name  = "prod/demo-api/config"

  data_json = jsonencode({
    username = "demo_user"
    password = "demo_pass_v1"
  })
}
