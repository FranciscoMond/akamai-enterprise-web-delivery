# Commenting out DNS management until dependency and/or deletion of existing zone is discussed and resolved
resource "akamai_dns_zone" "dns_zone" {
  contract       = local.contract_id
  zone           = local.dns.dns_zone
  type           = "primary"
  comment        = "DNS zone for group: ${local.group.akamai_group_prefix}-${var.environment}, managed via Terraform"
  group          = akamai_iam_group.akamai_group.id
  sign_and_serve = false
}

resource "akamai_dns_record" "dns_records" {
  for_each = { for r in local.dns_records : r.name => r }
  //All records won't deploy til edge hostname creation to account for records that require edge hostname
  //depends_on = [akamai_edge_hostname.edge_hostname]

  zone       = akamai_dns_zone.dns_zone.zone
  name       = each.key
  recordtype = each.value.type
  ttl        = each.value.ttl
  target     = each.value.target
}

data "tfe_outputs" "dns_ips" {
  for_each     = local.dns_ip_workspaces
  organization = local.group.tf_cloud_org
  workspace    = each.value
}