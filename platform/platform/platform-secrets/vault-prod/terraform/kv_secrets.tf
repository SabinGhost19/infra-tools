resource "vault_kv_secret_v2" "demo_api_config" {
  mount = local.secret_mount_path
  name  = "prod/demo-api/config"

  data_json = jsonencode({
    username = "demo_user"
    password = "demo_pass_v1"
  })
}

resource "vault_kv_secret_v2" "cicd_cosign_transit" {
  mount = local.secret_mount_path
  name  = "cicd/cosign-transit"

  data_json = jsonencode({
    VAULT_ADDR     = local.vault_addr
    VAULT_TOKEN    = vault_token.tekton_cosign_signer.client_token
    COSIGN_KEY_REF = "hashivault://cosign"
  })
}

resource "vault_kv_secret_v2" "cicd_harbor_robot" {
  mount = local.secret_mount_path
  name  = "cicd/harbor-robot"

  data_json = jsonencode({
    username = "harbor-registry-robot"
    password = "HarborRobotPass-2026-Demo"
  })
}

resource "vault_kv_secret_v2" "cicd_tekton_dashboard_oidc" {
  mount = local.secret_mount_path
  name  = "cicd/tekton-dashboard-oidc"

  data_json = jsonencode({
    client_id     = "tekton-dashboard-oidc"
    client_secret = "TektonOIDCSecret-2026-Demo"
    cookie_secret = "TektonCookieSecret-2026-Demo-1234567890"
  })
}
