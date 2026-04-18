provider "vault" {
  address = local.vault_addr
  token   = local.vault_token
}
