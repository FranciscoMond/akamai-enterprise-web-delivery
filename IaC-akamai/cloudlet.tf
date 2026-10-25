resource "akamai_cloudlets_policy" "forward_rewrite_policy" {
  name          = "fr_${var.environment}_policy"
  cloudlet_code = "FR"
  description   = "Forward Rewrite policy for ${var.environment}"
  group_id      = akamai_iam_group.akamai_group.id
  match_rules = templatefile("${path.module}/config/property-rules/cloudlet_forward_rewriter.json",
    {
      env       = var.environment,
      path_qs   = local.cloudlet.fr_path_qs,
      origin_id = local.property.rules.conditional-origin-group.origin-id,
      origin_id2 = local.property.rules.conditional-origin-group.origin-id2
  })
}

resource "akamai_cloudlets_policy_activation" "fr_activation_stg" {
  policy_id             = akamai_cloudlets_policy.forward_rewrite_policy.id
  network               = "STAGING"
  version               = akamai_cloudlets_policy.forward_rewrite_policy.version
  associated_properties = [akamai_property.hn_property.name]
}

resource "akamai_cloudlets_policy_activation" "fr_activation_prd" {
  policy_id             = akamai_cloudlets_policy.forward_rewrite_policy.id
  network               = "PRODUCTION"
  version               = akamai_cloudlets_policy.forward_rewrite_policy.version
  associated_properties = [akamai_property.hn_property.name]
  depends_on            = [akamai_cloudlets_policy_activation.fr_activation_stg]
}

resource "akamai_cloudlets_policy" "edge_redirector_policy" {
  name          = "er__${var.environment}_policy"
  cloudlet_code = "ER"
  description   = "Edge Redirector policy for ${var.environment}"
  group_id      = akamai_iam_group.akamai_group.id
  match_rules = templatefile("${path.module}/config/property-rules/cloudlet_edge_redirector.json",
    {
      env      = var.environment,
      core_env = local.group.env
  })
}

resource "akamai_cloudlets_policy_activation" "er_activation_stg" {
  policy_id             = akamai_cloudlets_policy.edge_redirector_policy.id
  network               = "STAGING"
  version               = akamai_cloudlets_policy.edge_redirector_policy.version
  associated_properties = [akamai_property.hn_property.name]
}

resource "akamai_cloudlets_policy_activation" "er_activation_prd" {
  policy_id             = akamai_cloudlets_policy.edge_redirector_policy.id
  network               = "PRODUCTION"
  version               = akamai_cloudlets_policy.edge_redirector_policy.version
  associated_properties = [akamai_property.hn_property.name]
  depends_on            = [akamai_cloudlets_policy_activation.er_activation_stg]
}