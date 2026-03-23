resource "keycloak_openid_client_default_scopes" "harbor" {
  realm_id  = data.keycloak_realm.zt.id
  client_id = keycloak_openid_client.harbor.id

  default_scopes = [
    "profile",
    "email",
    "roles",
    "web-origins",
  ]
}

resource "keycloak_openid_client_optional_scopes" "harbor" {
  realm_id  = data.keycloak_realm.zt.id
  client_id = keycloak_openid_client.harbor.id

  optional_scopes = [
    "address",
    "phone",
    "offline_access",
    "microprofile-jwt",
    "groups",
  ]
}
