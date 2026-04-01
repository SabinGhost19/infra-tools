resource "vault_kv_secret_v2" "demo_api_config" {
  mount      = vault_mount.kv.path
  name       = "prod/demo-api/config"
  depends_on = [vault_mount.kv]

  data_json = jsonencode({
    username = "demo_user"
    password = "demo_pass_v1"
  })
}

resource "vault_kv_secret_v2" "cicd_cosign_transit" {
  mount      = vault_mount.kv.path
  name       = "cicd/cosign-transit"
  depends_on = [vault_mount.kv, vault_transit_secret_backend_key.cosign]

  data_json = jsonencode({
    VAULT_ADDR     = local.vault_addr
    VAULT_TOKEN    = vault_token.tekton_cosign_signer.client_token
    COSIGN_KEY_REF = "hashivault://cosign"
  })
}

resource "vault_kv_secret_v2" "cicd_harbor_robot" {
  mount      = vault_mount.kv.path
  name       = "cicd/harbor-robot"
  depends_on = [vault_mount.kv]

  data_json = jsonencode({
    username = "harbor-registry-robot"
    password = "HarborRobotPass-2026-Demo"
  })
}

resource "vault_kv_secret_v2" "cicd_tekton_dashboard_oidc" {
  mount      = vault_mount.kv.path
  name       = "cicd/tekton-dashboard-oidc"
  depends_on = [vault_mount.kv]

  data_json = jsonencode({
    client_id     = "tekton-dashboard-oidc"
    client_secret = "TektonOIDCSecret-2026-Demo"
    cookie_secret = "TektonCookieSecret-2026-Demo-1234567890"
  })
}

# Export the Transit public key to a KV secret so that
# Kyverno and other consumers can verify cosign signatures
# without needing direct Transit access.
data "vault_transit_key" "cosign_pubkey" {
  backend    = vault_mount.transit.path
  name       = vault_transit_secret_backend_key.cosign.name
  depends_on = [vault_transit_secret_backend_key.cosign]
}

resource "vault_kv_secret_v2" "cicd_cosign_pubkey" {
  mount      = vault_mount.kv.path
  name       = "cicd/cosign-pubkey"
  depends_on = [vault_mount.kv, data.vault_transit_key.cosign_pubkey]

  data_json = jsonencode({
    "cosign.pub" = data.vault_transit_key.cosign_pubkey.keys["1"].public_key
  })
}
