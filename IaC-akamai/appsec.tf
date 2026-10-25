# App Sec Config
resource "akamai_appsec_configuration" "appsec_config" {
  name        = "MYDOMAIN_${var.environment}"
  description = "App Sec Configuration for ${var.environment}"
  contract_id = local.contract_id
  group_id    = akamai_iam_group.akamai_group.id
  host_names  = local.app_sec.config.match_target_hosts
}

resource "akamai_appsec_activations" "appsec_activation_stg" {
  config_id           = akamai_appsec_configuration.appsec_config.config_id
  network             = "STAGING"
  note                = "Configuration was activated to staging"
  notification_emails = local.group.emails
  version             = local.app_sec.config.stg_version
}

resource "akamai_appsec_activations" "appsec_activation_prd" {
  config_id           = akamai_appsec_configuration.appsec_config.config_id
  network             = "PRODUCTION"
  note                = "Configuration was activated to production"
  notification_emails = local.group.emails
  version             = local.app_sec.config.prd_version
  depends_on          = [akamai_appsec_activations.appsec_activation_stg]
}

# Security Policy
resource "akamai_appsec_security_policy" "security_policy" {
  config_id              = akamai_appsec_configuration.appsec_config.config_id
  security_policy_name   = "[${var.environment}]"
  security_policy_prefix = var.environment != "prod" ? "nonp" : "prod"
}
/*
# Security Policy Advanced Pragma Header
resource "akamai_appsec_advanced_settings_pragma_header" "pragma_header" {
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  pragma_header      = file("${path.module}/config/app-sec/pragma-header.json")
  depends_on         = [akamai_appsec_security_policy.security_policy]
}
*/
# Security Policy SIEM Settings
resource "akamai_appsec_siem_settings" "my_siem_settings" {
  config_id              = akamai_appsec_configuration.appsec_config.config_id
  enable_siem             = true
  enable_for_all_policies = true
  siem_id                 = 1
}

# Security Policy Details
resource "akamai_appsec_match_target" "match_target" {
  config_id = akamai_appsec_configuration.appsec_config.config_id
  match_target = templatefile("${path.module}/config/app-sec/match-target.json", {
    match_hostnames = jsonencode(local.app_sec.config.match_target_hosts),
    match_type      = local.app_sec.config.match_type
    sec_policy_id   = akamai_appsec_security_policy.security_policy.security_policy_id
    bypass_nl_id    = akamai_networklist_network_list.bypass_nl.network_list_id
    bypass_nl_name  = akamai_networklist_network_list.bypass_nl.name
  })
  # Akamai Provider Bug: match_target resource is dynamically setting the targetId value for the match_target json
  # Can't specify this via code because this attribute is created post apply for the resource
  # Impact: Every plan will say the targetId will be removed, but it will be added/kept during apply
}

# IP/Geo Firewall 
resource "akamai_appsec_ip_geo_protection" "ip_geo_protection" {
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id = akamai_appsec_security_policy.security_policy.security_policy_id
  enabled            = local.app_sec.protections.ip_geo
}

resource "akamai_appsec_ip_geo" "ip_geo_block" {
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id = akamai_appsec_security_policy.security_policy.security_policy_id
  mode               = "block"
 ip_controls {
    action           = "deny"
    ip_network_lists = [akamai_networklist_network_list.block_nl.network_list_id]
  }
  depends_on         = [akamai_appsec_ip_geo_protection.ip_geo_protection]
}

# DoS Protection
resource "akamai_appsec_rate_protection" "rate_protection" {
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id = akamai_appsec_security_policy.security_policy.security_policy_id
  enabled            = local.app_sec.protections.rate
}

resource "akamai_appsec_rate_policy" "rate_policy" {
  for_each  = local.app_sec.rate_policies
  config_id = akamai_appsec_configuration.appsec_config.config_id
  rate_policy = templatefile("${path.module}/config/app-sec/${each.key}.json", {
    threshold = each.value.threshold
  })
}

resource "akamai_appsec_rate_policy_action" "rate_policy_action" {
  for_each           = akamai_appsec_rate_policy.rate_policy
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id = akamai_appsec_security_policy.security_policy.security_policy_id
  rate_policy_id     = each.value.rate_policy_id
  ipv4_action        = lookup(local.app_sec.rate_policy_actions, jsondecode(each.value.rate_policy).name, null)
  ipv6_action        = lookup(local.app_sec.rate_policy_actions, jsondecode(each.value.rate_policy).name, null)
  depends_on         = [akamai_appsec_rate_protection.rate_protection]
}

resource "akamai_appsec_slowpost_protection" "slow_protection" {
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id = akamai_appsec_security_policy.security_policy.security_policy_id
  enabled            = local.app_sec.protections.slow
}

resource "akamai_appsec_slow_post" "slow_post" {
  config_id                  = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id         = akamai_appsec_security_policy.security_policy.security_policy_id
  slow_rate_action           = local.app_sec.config.slow_rate_action
  slow_rate_threshold_rate   = local.app_sec.config.slow_rate_threshold_rate
  slow_rate_threshold_period = local.app_sec.config.slow_rate_threshold_period
  depends_on                 = [akamai_appsec_slowpost_protection.slow_protection]
}

# Custom Rules
resource "akamai_appsec_custom_rule" "custom_rule" {
  config_id   = akamai_appsec_configuration.appsec_config.config_id
  custom_rule = templatefile("${path.module}/config/app-sec/custom-rule.json", {})
}

resource "akamai_appsec_custom_rule_action" "create_custom_rule_action" {
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id = akamai_appsec_security_policy.security_policy.security_policy_id
  custom_rule_id     = akamai_appsec_custom_rule.custom_rule.custom_rule_id
  custom_rule_action = local.app_sec.config.custom_rule_action
}

# Web Application Firewall
resource "akamai_appsec_waf_protection" "waf_protection" {
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id = akamai_appsec_security_policy.security_policy.security_policy_id
  enabled            = local.app_sec.protections.waf
}

resource "akamai_appsec_attack_group" "attack_group_action" {
  for_each            = local.app_sec.waf_attack_group
  config_id           = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id  = akamai_appsec_security_policy.security_policy.security_policy_id
  attack_group        = each.key
  attack_group_action = each.value
  depends_on          = [akamai_appsec_waf_protection.waf_protection]
}

resource "akamai_appsec_penalty_box" "penalty_box" {
  config_id              = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id     = akamai_appsec_security_policy.security_policy.security_policy_id
  penalty_box_protection = local.app_sec.protections.penalty_box
  penalty_box_action     = local.app_sec.config.penalty_box_action
  depends_on             = [akamai_appsec_waf_protection.waf_protection]
}

# API Request Constraints
resource "akamai_appsec_api_constraints_protection" "api_protection" {
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id = akamai_appsec_security_policy.security_policy.security_policy_id
  enabled            = local.app_sec.protections.api
}

# Client Reputation
resource "akamai_appsec_reputation_protection" "reputation_protection" {
  config_id          = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id = akamai_appsec_security_policy.security_policy.security_policy_id
  enabled            = local.app_sec.protections.reputation
}

data "akamai_appsec_reputation_profiles" "reputation_profiles" {
  config_id = akamai_appsec_configuration.appsec_config.config_id
}

resource "akamai_appsec_reputation_profile_action" "reputation_action" {
  for_each              = local.app_sec.reputation_profile
  config_id             = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id    = akamai_appsec_security_policy.security_policy.security_policy_id
  reputation_profile_id = lookup(local.reputation_profiles, each.key, null)
  action                = each.value
  depends_on            = [akamai_appsec_reputation_protection.reputation_protection]
}

/*
# Can't add due to an akamai terraform bug, they don't provide these 2 parameters despite documentation
data "akamai_appsec_reputation_profile_analysis" "reputation_analysis" {
  config_id              = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id     = akamai_appsec_security_policy.security_policy.security_policy_id
  forward_to_http_header = true
  forward_shared_ip_to_http_header_siem = true
  depends_on = [ akamai_appsec_reputation_protection.reputation_protection ]
}*/