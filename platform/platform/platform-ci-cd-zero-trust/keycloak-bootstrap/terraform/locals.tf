locals {
  keycloak_url                  = "http://keycloak.platform-identity.svc.cluster.local"
  keycloak_admin_username       = "admin"
  keycloak_admin_password       = "ChangeMe123!"
  realm_name                    = "ZeroTrust-Realm"
  harbor_client_secret          = "HarborOIDCSecret-2026-Demo"
  tekton_client_secret          = "TektonOIDCSecret-2026-Demo"
  jit_backend_client_secret     = "ChangeMe-JITBackend-2026!"
  harbor_redirect_uri           = "https://harbor.licenta.local/c/oidc/callback"
  tekton_dashboard_redirect_uri = "https://tekton.licenta.local/oauth2/callback"

  ldap_connection_url       = "ldaps://ipa.licenta.local:636"
  ldap_users_dn             = "cn=users,cn=accounts,dc=licenta,dc=local"
  ldap_bind_dn              = "uid=keycloak-svc,cn=users,cn=accounts,dc=licenta,dc=local"
  ldap_bind_password        = "ParolaSetaInAnsible123!"
  ldap_groups_dn            = "cn=groups,cn=accounts,dc=licenta,dc=local"
  ldap_user_object_classes  = ["person", "organizationalperson", "inetorgperson"]
  ldap_group_object_classes = ["groupofnames"]
}
