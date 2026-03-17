terraform {
  required_version = ">= 1.6.0"
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "~> 4.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

variable "keycloak_base_url" { type = string }
variable "keycloak_user" { type = string }
variable "keycloak_password" {
  type      = string
  sensitive = true
}

provider "keycloak" {
  client_id = "admin-cli"
  realm     = "master"
  username  = var.keycloak_user
  password  = var.keycloak_password
  url       = var.keycloak_base_url
}

provider "kubernetes" {
  host                   = "https://kubernetes.default.svc"
  token                  = file("/var/run/secrets/kubernetes.io/serviceaccount/token")
  cluster_ca_certificate = file("/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
}

resource "keycloak_realm" "zero_trust" {
  realm   = "ZeroTrust-Realm"
  enabled = true
}

resource "keycloak_openid_client" "oauth2_proxy" {
  realm_id                     = keycloak_realm.zero_trust.id
  client_id                    = "oauth2-proxy"
  name                         = "oauth2-proxy"
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false
  implicit_flow_enabled        = false
  service_accounts_enabled     = false
  valid_redirect_uris          = ["http://demo.licenta.ro/oauth2/callback"]
  web_origins                  = ["http://demo.licenta.ro"]
}

resource "keycloak_openid_group_membership_protocol_mapper" "groups_claim" {
  realm_id            = keycloak_realm.zero_trust.id
  client_id           = keycloak_openid_client.oauth2_proxy.id
  name                = "groups"
  claim_name          = "groups"
  full_path           = false
  add_to_access_token = true
  add_to_id_token     = true
  add_to_userinfo     = true
}

resource "kubernetes_namespace_v1" "oauth2_proxy" {
  metadata {
    name = "oauth2-proxy"
  }
}

resource "random_password" "oauth2_cookie_secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret_v1" "oauth2_proxy_creds" {
  metadata {
    name      = "oauth2-proxy-creds"
    namespace = kubernetes_namespace_v1.oauth2_proxy.metadata[0].name
  }

  type = "Opaque"

  data = {
    OAUTH2_PROXY_CLIENT_ID     = keycloak_openid_client.oauth2_proxy.client_id
    OAUTH2_PROXY_CLIENT_SECRET = keycloak_openid_client.oauth2_proxy.client_secret
    OAUTH2_PROXY_COOKIE_SECRET = random_password.oauth2_cookie_secret.result
  }
}
