# App Security Config Network Lists
resource "akamai_networklist_network_list" "block_nl" {
  name        = "gcp_${var.environment}_BlockList"
  type        = "IP"
  description = "Block List (IP) for ${var.environment}"
  list = []
  mode = "APPEND"
}

resource "akamai_networklist_activations" "block_activation_stg" {
  network_list_id     = akamai_networklist_network_list.block_nl.network_list_id
  network             = "STAGING"
  sync_point          = akamai_networklist_network_list.block_nl.sync_point
  notes               = "Activation to stage"
  notification_emails = local.group.emails
}

resource "akamai_networklist_activations" "block_activation_prd" {
  network_list_id     = akamai_networklist_network_list.block_nl.network_list_id
  network             = "PRODUCTION"
  sync_point          = akamai_networklist_network_list.block_nl.sync_point
  notes               = "Activation to production"
  notification_emails = local.group.emails
  depends_on          = [akamai_networklist_activations.block_activation_stg]
}

resource "akamai_networklist_network_list" "bypass_nl" {
  name        = "gcp_${var.environment}_BypassList"
  type        = "IP"
  description = "White/Bypass List (IP) for ${var.environment}"
  list        = local.bypass_ips
  mode        = "APPEND"
}

resource "akamai_networklist_activations" "bypass_activation_stg" {
  network_list_id     = akamai_networklist_network_list.bypass_nl.network_list_id
  network             = "STAGING"
  sync_point          = akamai_networklist_network_list.bypass_nl.sync_point
  notes               = "Activation to stage"
  notification_emails = local.group.emails
}

resource "akamai_networklist_activations" "bypass_activation_prd" {
  network_list_id     = akamai_networklist_network_list.bypass_nl.network_list_id
  network             = "PRODUCTION"
  sync_point          = akamai_networklist_network_list.bypass_nl.sync_point
  notes               = "Activation to production"
  notification_emails = local.group.emails
  depends_on          = [akamai_networklist_activations.bypass_activation_stg]
}