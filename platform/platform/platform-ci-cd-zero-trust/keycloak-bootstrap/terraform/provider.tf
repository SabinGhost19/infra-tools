provider "keycloak" {
  client_id = "admin-cli"
  username  = local.keycloak_admin_username
  password  = local.keycloak_admin_password
  url       = local.keycloak_url
}
