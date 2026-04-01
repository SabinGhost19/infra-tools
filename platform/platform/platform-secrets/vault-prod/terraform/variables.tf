variable "vault_token" {
  type        = string
  description = "The Vault root token used to bootstrap the cluster. Injected securely via Kubernetes Secret."
  sensitive   = true
}
