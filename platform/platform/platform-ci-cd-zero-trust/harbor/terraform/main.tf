terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    harbor = {
      source  = "goharbor/harbor"
      version = "3.10.11"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.2"
    }
  }
}

variable "vault_token" {
  type      = string
  sensitive = true
}

locals {
  harbor_url            = "https://harbor.licenta.local"
  harbor_admin_username = "admin"
  harbor_admin_password = "HarborAdminPass-2026-Demo"
  harbor_project_name   = "project-licenta"
  harbor_robot_name     = "tekton-push-pull"

  vault_addr        = "http://vault-prod.vault-prod.svc.cluster.local:8200"
  secret_mount_path = "secret"
}

provider "harbor" {
  url      = local.harbor_url
  username = local.harbor_admin_username
  password = local.harbor_admin_password
  insecure = true
}

provider "vault" {
  address = local.vault_addr
  token   = var.vault_token
}

resource "random_password" "harbor_robot_secret" {
  length  = 32
  special = false
}

resource "harbor_project" "project_licenta" {
  name                   = local.harbor_project_name
  public                 = false
  vulnerability_scanning = true
}

resource "harbor_robot_account" "project_licenta_tekton" {
  name        = local.harbor_robot_name
  description = "Project-scoped robot for Tekton push/pull"
  level       = "project"
  secret      = random_password.harbor_robot_secret.result

  permissions {
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "push"
      resource = "repository"
    }
    kind      = "project"
    namespace = harbor_project.project_licenta.name
  }
}

resource "vault_kv_secret_v2" "cicd_harbor_project_licenta_robot" {
  mount = local.secret_mount_path
  name  = "cicd/harbor-project-licenta-robot"

  data_json = jsonencode({
    username = harbor_robot_account.project_licenta_tekton.full_name
    password = random_password.harbor_robot_secret.result
  })
}
