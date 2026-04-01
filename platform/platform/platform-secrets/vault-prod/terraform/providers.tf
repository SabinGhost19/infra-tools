provider "vault" {
  address = local.vault_addr
  token   = var.vault_token
}
