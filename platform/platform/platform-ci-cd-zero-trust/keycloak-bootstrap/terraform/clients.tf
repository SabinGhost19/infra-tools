resource "keycloak_openid_client" "harbor" {
  realm_id                     = data.keycloak_realm.zt.id
  client_id                    = "harbor-oidc"
  name                         = "harbor-oidc"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris          = [local.harbor_redirect_uri]
  web_origins                  = ["https://harbor.licenta.local"]
  client_secret                = local.harbor_client_secret
}

resource "keycloak_openid_client" "tekton_dashboard" {
  realm_id                     = data.keycloak_realm.zt.id
  client_id                    = "tekton-dashboard-oidc"
  name                         = "tekton-dashboard-oidc"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  valid_redirect_uris          = [local.tekton_dashboard_redirect_uri]
  web_origins                  = ["https://tekton.licenta.local"]
  client_secret                = local.tekton_client_secret
}

resource "keycloak_openid_client" "jit_backend" {
  realm_id                     = data.keycloak_realm.zt.id
  client_id                    = "jit-backend-api"
  name                         = "jit-backend-api"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = true
  valid_redirect_uris          = []
  web_origins                  = []
  client_secret                = local.jit_backend_client_secret
}

data "keycloak_role" "realm_management_manage_users" {
  realm_id  = data.keycloak_realm.zt.id
  client_id = "realm-management"
  name      = "manage-users"
}

resource "keycloak_openid_client_service_account_role" "jit_backend_manage_users" {
  realm_id                = data.keycloak_realm.zt.id
  service_account_user_id = keycloak_openid_client.jit_backend.service_account_user_id
  client_id               = "realm-management"
  role                    = data.keycloak_role.realm_management_manage_users.name
}
