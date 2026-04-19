resource "vault_mount" "kvv2" {
  path        = local.secret_mount_path
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}
