resource "akamai_datastream" "splunk_datastream" {
  active = true
  delivery_configuration {
    format = "JSON"
    frequency {
      interval_in_secs = 30
    }
  }
  contract_id    = local.contract_id
  dataset_fields = local.datastreamSplunk.dataset_fields.dataset_field_id
  group_id       = akamai_iam_group.akamai_group.id
  properties     = [local.property_id]
  stream_name    = "${var.environment}_${local.datastreamSplunk.stream_name}"
  splunk_connector {
    endpoint              = local.datastreamSplunk.destination.endpoint
    compress_logs         = true
    display_name          = local.datastreamSplunk.destination.display_name
    event_collector_token = local.datastreamSplunk.destination.event_collector_token
  }
  notification_emails = local.group.emails
  collect_midgress    = false
}