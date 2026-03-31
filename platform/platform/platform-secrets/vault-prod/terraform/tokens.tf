resource "vault_token" "tekton_cosign_signer" {
  policies          = [vault_policy.cicd_cosign_transit_policy.name]
  renewable         = true
  no_default_policy = true
  ttl               = "24h"
  explicit_max_ttl  = "720h"
}
