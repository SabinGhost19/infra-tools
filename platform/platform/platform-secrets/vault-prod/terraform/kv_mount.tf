# In production (non-dev) mode, the KV v2 secrets engine
# is NOT automatically mounted. We must create it explicitly.
resource "vault_mount" "kv" {
  path        = local.secret_mount_path
  type        = "kv-v2"
  description = "KV v2 secrets engine for platform secrets"
}
