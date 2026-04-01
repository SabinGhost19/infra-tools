resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = local.kubernetes_auth_path
}

resource "vault_kubernetes_auth_backend_config" "config" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = "https://kubernetes.default.svc"
  kubernetes_ca_cert     = file("/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
  disable_iss_validation = true
}

resource "vault_kubernetes_auth_backend_role" "demo_api_prod_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "demo-api-prod-role"
  bound_service_account_names      = ["default", "external-secrets"]
  bound_service_account_namespaces = ["default", "external-secrets"]
  token_policies                   = [vault_policy.demo_api_policy.name]
  token_ttl                        = 3600
}

resource "vault_kubernetes_auth_backend_role" "tekton_cosign_signer_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "tekton-cosign-signer-role"
  bound_service_account_names      = ["tekton-builder"]
  bound_service_account_namespaces = ["test-workload-spire-tekton"]
  token_policies                   = [vault_policy.cicd_cosign_transit_policy.name]
  token_ttl                        = 3600
}

resource "vault_kubernetes_auth_backend_role" "harbor_project_bootstrap_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "harbor-project-bootstrap-role"
  bound_service_account_names      = ["tf-runner"]
  bound_service_account_namespaces = ["harbor"]
  token_policies                   = [vault_policy.harbor_project_bootstrap_policy.name]
  token_ttl                        = 3600
}
