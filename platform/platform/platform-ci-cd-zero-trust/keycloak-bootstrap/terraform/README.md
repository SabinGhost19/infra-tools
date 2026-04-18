# Keycloak Bootstrap Terraform

This Terraform module manages OIDC clients for the ZeroTrust-Realm in Keycloak.

## Keycloak terminology

- Realm: A tenant boundary that contains users, groups, roles, clients, and authentication settings.
- Client: An application that delegates authentication to Keycloak (for example Harbor or Tekton Dashboard).
- Redirect URI: Allowed callback URL where Keycloak sends the authorization code after login.
- Web Origin: Allowed browser origin for CORS checks.
- Client Scopes: Bundles of protocol mappers and claims used in tokens.
- Default Scopes: Scopes always included for the client.
- Optional Scopes: Scopes included only when requested with the OAuth scope parameter.

## Terraform resources in this folder

- provider.tf: Configures the Keycloak Terraform provider.
- versions.tf: Defines Terraform and provider version constraints.
- locals.tf: Stores module constants (realm, client secrets, redirect URIs).
- realm-data.tf: Reads the existing ZeroTrust-Realm.
- clients.tf: Creates and manages OIDC clients:
  - harbor-oidc
  - tekton-dashboard-oidc
  - jit-backend-api (service account enabled for M2M admin operations)
- ldap-federation.tf: Configures LDAP user federation and group sync mapper for FreeIPA:
  - freeipa-ldap user federation provider
  - freeipa-group-mapper group mapper
- harbor-client-scopes.tf: Attaches default and optional client scopes to harbor-oidc, including groups.

## Behavior summary

- Harbor uses OIDC Authorization Code flow with confidential client credentials.
- Tekton Dashboard uses a separate confidential OIDC client.
- JIT backend uses client credentials to call Keycloak Admin APIs with delegated `manage-users` role.
- FreeIPA users and groups are federated into ZeroTrust-Realm using LDAP over LDAPS.
- Harbor client scopes are managed as code to avoid manual Keycloak UI drift.

## DNS and FreeIPA connectivity notes

- You do not need a separate dedicated DNS server if FreeIPA DNS is enabled (`--setup-dns`) and reachable.
- Keycloak must resolve `ipa.licenta.local` to the FreeIPA IP (currently `10.102.14.193`) to keep LDAPS certificate hostname validation valid.
- Recommended options when no enterprise DNS exists:
  - Configure network DNS clients to use FreeIPA DNS directly.
  - Add conditional forwarding/stub-domain from cluster DNS (CoreDNS) for `licenta.local` to FreeIPA.
  - Temporary fallback for lab environments: static host mapping for Keycloak runtime (hostAliases or node-level `/etc/hosts`).
- Avoid replacing `ldaps://ipa.licenta.local:636` with an IP URL unless certificate SANs explicitly include that IP.

## Troubleshooting: provider download fails in tf-runner

If runner logs show errors similar to:

- `Failed to install provider`
- `GET https://github.com/keycloak/terraform-provider-keycloak/releases/...`

then the runner pod cannot reach GitHub release assets.

Recommended actions:

1. Ensure outbound egress from namespace `platform-identity` to `github.com` and release/CDN endpoints.
2. Reconcile the Terraform object after egress is fixed.
