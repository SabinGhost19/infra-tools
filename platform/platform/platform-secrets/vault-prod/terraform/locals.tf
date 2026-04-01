# NOTE: In production HA raft mode, Vault starts sealed.
# After deployment, run:
#   kubectl -n vault-prod exec vault-prod-0 -- vault operator init
#   kubectl -n vault-prod exec vault-prod-0 -- vault operator unseal <key1>
#   kubectl -n vault-prod exec vault-prod-0 -- vault operator unseal <key2>
#   kubectl -n vault-prod exec vault-prod-0 -- vault operator unseal <key3>
# Then join and unseal vault-prod-1 and vault-prod-2:
#   kubectl -n vault-prod exec vault-prod-1 -- vault operator raft join http://vault-prod-0.vault-prod-internal:8200
#   kubectl -n vault-prod exec vault-prod-1 -- vault operator unseal <key1> ...
# Store the root token for Terraform use.
locals {
  vault_addr           = "http://vault-prod.vault-prod.svc.cluster.local:8200"
  vault_token          = "" # Token supplied via TF_VAR_vault_token from k8s secret
  secret_mount_path    = "secret"
  kubernetes_auth_path = "kubernetes"
  transit_mount_path   = "transit"
  cosign_transit_key   = "cosign"
}
