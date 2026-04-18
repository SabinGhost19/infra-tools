resource "keycloak_ldap_user_federation" "freeipa" {
  realm_id = data.keycloak_realm.zt.id
  name     = "freeipa-ldap"
  enabled  = true

  priority           = 0
  import_enabled     = true
  edit_mode          = "READ_ONLY"
  sync_registrations = true
  vendor             = "RHDS"

  username_ldap_attribute = "uid"
  rdn_ldap_attribute      = "uid"
  uuid_ldap_attribute     = "ipaUniqueID"
  user_object_classes     = local.ldap_user_object_classes

  connection_url      = local.ldap_connection_url
  users_dn            = local.ldap_users_dn
  bind_dn             = local.ldap_bind_dn
  bind_credential     = local.ldap_bind_password
  search_scope        = "SUBTREE"
  connection_timeout  = "5s"
  read_timeout        = "10s"
  trust_email         = true
  use_truststore_spi  = "ONLY_FOR_LDAPS"
  connection_pooling  = false
  pagination          = true
  full_sync_period    = 3600
  changed_sync_period = 300
}

resource "keycloak_ldap_group_mapper" "freeipa_groups" {
  realm_id                = data.keycloak_realm.zt.id
  ldap_user_federation_id = keycloak_ldap_user_federation.freeipa.id
  name                    = "freeipa-group-mapper"

  ldap_groups_dn                 = local.ldap_groups_dn
  group_name_ldap_attribute      = "cn"
  group_object_classes           = local.ldap_group_object_classes
  membership_ldap_attribute      = "member"
  membership_attribute_type      = "DN"
  membership_user_ldap_attribute = "uid"
  memberof_ldap_attribute        = "memberOf"

  mode                         = "READ_ONLY"
  preserve_group_inheritance   = true
  ignore_missing_groups        = true
  user_roles_retrieve_strategy = "GET_GROUPS_FROM_USER_MEMBEROF_ATTRIBUTE"
}
