terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "~> 5.0"
    }
  }
}

locals {
  keycloak_url                 = "http://keycloak.platform-identity.svc.cluster.local"
  keycloak_admin_username      = "admin"
  keycloak_admin_password      = "AdminPass-2026-Demo"
  realm_name                   = "ZeroTrust-Realm"
  harbor_client_secret         = "HarborOIDCSecret-2026-Demo"
  tekton_client_secret         = "TektonOIDCSecret-2026-Demo"
  harbor_redirect_uri          = "https://harbor.licenta.local/c/oidc/callback"
  tekton_dashboard_redirect_uri = "https://tekton.licenta.local/oauth2/callback"
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = local.keycloak_admin_username
  password  = local.keycloak_admin_password
  url       = local.keycloak_url
}

data "keycloak_realm" "zt" {
  realm = local.realm_name
}

resource "keycloak_openid_client" "harbor" {
  realm_id                        = data.keycloak_realm.zt.id
  client_id                       = "harbor-oidc"
  name                            = "harbor-oidc"
  enabled                         = true
  access_type                     = "CONFIDENTIAL"
  standard_flow_enabled           = true
  direct_access_grants_enabled    = false
  service_accounts_enabled        = false
  valid_redirect_uris             = [local.harbor_redirect_uri]
  web_origins                     = ["https://harbor.licenta.local"]
  client_secret                   = local.harbor_client_secret
}

resource "keycloak_openid_client" "tekton_dashboard" {
  realm_id                        = data.keycloak_realm.zt.id
  client_id                       = "tekton-dashboard-oidc"
  name                            = "tekton-dashboard-oidc"
  enabled                         = true
  access_type                     = "CONFIDENTIAL"
  standard_flow_enabled           = true
  direct_access_grants_enabled    = false
  service_accounts_enabled        = false
  valid_redirect_uris             = [local.tekton_dashboard_redirect_uri]
  web_origins                     = ["https://tekton.licenta.local"]
  client_secret                   = local.tekton_client_secret
}
