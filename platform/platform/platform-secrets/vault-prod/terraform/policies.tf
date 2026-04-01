resource "vault_policy" "demo_api_policy" {
  name   = "demo-api-policy"
  policy = <<-EOT
path "secret/data/prod/demo-api/*" {
  capabilities = ["read"]
}

path "secret/data/cicd/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_policy" "cicd_cosign_transit_policy" {
  name   = "cicd-cosign-transit-policy"
  policy = <<-EOT
path "transit/sign/cosign" {
  capabilities = ["update"]
}

path "transit/verify/cosign" {
  capabilities = ["update"]
}

path "transit/keys/cosign" {
  capabilities = ["read"]
}

path "secret/data/cicd/cosign-transit" {
  capabilities = ["read"]
}

path "secret/data/cicd/cosign-pubkey" {
  capabilities = ["read"]
}
EOT
}

resource "vault_policy" "harbor_project_bootstrap_policy" {
  name   = "harbor-project-bootstrap-policy"
  policy = <<-EOT
path "secret/data/cicd/harbor-project-licenta-robot" {
  capabilities = ["create", "read", "update", "delete"]
}
EOT
}
