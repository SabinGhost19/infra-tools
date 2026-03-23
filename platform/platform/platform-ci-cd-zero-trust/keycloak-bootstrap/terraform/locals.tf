locals {
  keycloak_url                  = "http://keycloak.platform-identity.svc.cluster.local"
  keycloak_admin_username       = "admin"
  keycloak_admin_password       = "ChangeMe123!"
  realm_name                    = "ZeroTrust-Realm"
  harbor_client_secret          = "HarborOIDCSecret-2026-Demo"
  tekton_client_secret          = "TektonOIDCSecret-2026-Demo"
  harbor_redirect_uri           = "https://harbor.licenta.local/c/oidc/callback"
  tekton_dashboard_redirect_uri = "https://tekton.licenta.local/oauth2/callback"
}
