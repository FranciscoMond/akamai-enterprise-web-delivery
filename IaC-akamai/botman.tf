# Bot Management
resource "akamai_botman_bot_management_settings" "bot_management_settings" {
  config_id               = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id      = akamai_appsec_security_policy.security_policy.security_policy_id
  bot_management_settings = jsonencode(local.app_sec.bot_management_settings)
}

data "akamai_botman_akamai_bot_category" "akamai_bot_categories" {
}

resource "akamai_botman_akamai_bot_category_action" "akamai_bot_categories_action" {
  for_each                   = local.app_sec.bot_category
  config_id                  = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id         = akamai_appsec_security_policy.security_policy.security_policy_id
  category_id                = lookup(local.bot_categories, each.key, null)
  akamai_bot_category_action = jsonencode(each.value)
}

data "akamai_botman_bot_detection" "detection_catgories" {
}

resource "akamai_botman_bot_detection_action" "detection_categories_action" {
  for_each             = local.app_sec.detection_category
  config_id            = akamai_appsec_configuration.appsec_config.config_id
  security_policy_id   = akamai_appsec_security_policy.security_policy.security_policy_id
  detection_id         = lookup(local.detection_catgories, each.key, null)
  bot_detection_action = jsonencode(each.value)
}