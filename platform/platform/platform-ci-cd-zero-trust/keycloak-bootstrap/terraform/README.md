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
- harbor-client-scopes.tf: Attaches default and optional client scopes to harbor-oidc, including groups.

## Behavior summary

- Harbor uses OIDC Authorization Code flow with confidential client credentials.
- Tekton Dashboard uses a separate confidential OIDC client.
- Harbor client scopes are managed as code to avoid manual Keycloak UI drift.
