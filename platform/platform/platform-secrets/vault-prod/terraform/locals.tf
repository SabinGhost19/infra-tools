locals {
  vault_addr           = "http://vault-prod.vault-prod.svc.cluster.local:8200"
  vault_token          = "hvs.8mGiyJiMladDU0JwqWfRFPRf"
  secret_mount_path    = "secret"
  kubernetes_auth_path = "kubernetes"
  transit_mount_path   = "transit"
  cosign_transit_key   = "cosign"
}
