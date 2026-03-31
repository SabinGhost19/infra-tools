resource "vault_mount" "transit" {
  path        = local.transit_mount_path
  type        = "transit"
  description = "Transit engine for CI/CD image signing"
}

resource "vault_transit_secret_backend_key" "cosign" {
  backend          = vault_mount.transit.path
  name             = local.cosign_transit_key
  type             = "ecdsa-p256"
  deletion_allowed = false
  exportable       = false
}
