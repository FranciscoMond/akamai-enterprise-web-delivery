resource "akamai_cp_code" "cp_code" {
  name        = "${var.environment}-cp"
  contract_id = data.akamai_contract.parent_contract.id
  group_id    = "grp_${akamai_iam_group.akamai_group.id}"
  product_id  = local.property.product_id
}

resource "akamai_edge_hostname" "edge_hostname" {
  product_id          = local.property.product_id
  contract_id         = data.akamai_contract.parent_contract.id
  group_id            = "grp_${akamai_iam_group.akamai_group.id}"
  edge_hostname       = local.dns.edge_hostname
  ip_behavior         = "IPV6_COMPLIANCE"
  status_update_email = local.group.emails
  certificate         = local.cert_enrollment_id
}

resource "akamai_property" "mydomain_property" {
  name        = "${local.group.akamai_group_prefix}-${var.environment}"
  product_id  = local.property.product_id
  contract_id = local.contract_id
  group_id    = akamai_iam_group.akamai_group.id
  rule_format = "v2025-01-13"
  # Used to hide the pem values from terraform plan output (Will hide the whole rule json for the property)
  # Take off the sensitive function if you need to see the property rule json for debugging purposes (ie. tf plans)
  rules = sensitive(data.akamai_property_rules_builder.default_rule.json)
  hostnames {
    cname_from             = local.dns.dns_zone
    cname_to               = akamai_edge_hostname.edge_hostname.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  hostnames {
    cname_from             = "*.${local.dns.dns_zone}"
    cname_to               = akamai_edge_hostname.edge_hostname.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
}

resource "akamai_property_activation" "property_activation" {
  property_id                    = akamai_property.hn_property.id
  network                        = "STAGING"
  contact                        = local.group.emails
  note                           = "property activation"
  version                        = local.property.activation_stg.latest ? akamai_property.hn_property.latest_version : local.property.activation_stg.version
  auto_acknowledge_rule_warnings = true //Need to set to true or activation will fail due to warnings/recommendations
}

resource "akamai_property_activation" "property_activation_prd" {
  property_id                    = akamai_property.hn_property.id
  network                        = "PRODUCTION"
  contact                        = local.group.emails
  note                           = "property activation" 
  version                        = local.property.activation_prd.latest ? akamai_property.hn_property.latest_version : local.property.activation_prd.version
  auto_acknowledge_rule_warnings = true //Need to set to true or activation will fail due to warnings/recommendations
  depends_on                     = [akamai_property_activation.property_activation]
}

data "akamai_cps_enrollments" "cps_enrollments" {
  contract_id = local.contract_id
}