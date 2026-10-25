data "akamai_contract" "parent_contract" {
  group_name = local.group.akamai_parent_group_name
}

resource "akamai_iam_group" "akamai_group" {
  parent_group_id = local.parent_group_id
  name            = "${local.group.akamai_group_prefix}-${var.environment}"
}