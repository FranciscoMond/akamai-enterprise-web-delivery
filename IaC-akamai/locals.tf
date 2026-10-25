locals {
  group               = var.group
  parent_group_id     = trimprefix(data.akamai_contract.parent_contract.group_id, "grp_")
  contract_id         = trimprefix(data.akamai_contract.parent_contract.id, "ctr_")
  property_id         = trimprefix(akamai_property.hn_property.id, "prp_")
  dns                 = var.dns
  property            = var.property
  cloudlet            = var.cloudlet
  app_sec             = var.app-sec
  network_list        = var.network_list
  datastreamSplunk    = var.datastreamSplunk
  control_ips         = concat( 
                                var.network_list.bypass,
                                var.network_list.google-global-ips,
                                var.network_list.google-central-us-1-ips,
                                var.network_list.google-east-us-1-ips,
                                var.network_list.google-west-europe-1-ips,
                                var.network_list.qa-testing-ips,                         
                                var.network_list.aws-ips,
                              )
  bypass_ips          = concat( 
                                var.network_list.bypass,
                                var.network_list.google-global-ips,
                                var.network_list.google-central-us-1-ips,
                                var.network_list.google-east-us-1-ips,
                                var.network_list.google-west-europe-1-ips,
                                var.network_list.qa-testing-ips,                         
                                var.network_list.aws-ips,
                              )
  reputation_profiles = { for rep in jsondecode(data.akamai_appsec_reputation_profiles.reputation_profiles.json).reputationProfiles : rep.name => rep.id }
  bot_categories      = { for cat in jsondecode(data.akamai_botman_akamai_bot_category.akamai_bot_categories.json).categories : cat.categoryName => cat.categoryId }
  detection_catgories = { for det in jsondecode(data.akamai_botman_bot_detection.detection_catgories.json).detections : det.detectionName => det.detectionId }

  cert_enrollment_id = try(
    [
      for enrollment in data.akamai_cps_enrollments.cps_enrollments.enrollments :
      enrollment.enrollment_id
      if enrollment.common_name == "mydomain.com"
    ][0], null
  )
  cert_urls = {}
  processed_certs_urls = merge([
    for cert_url_name, cert_url_data in data.tls_certificate.cert_urls : {
      for cert in cert_url_data.certificates :
      "${cert_url_name}_${cert.is_ca ? (cert.issuer == cert.subject ? "root" : "intermediate") : "server"}" => {
        pem        = replace(cert.cert_pem, "\n", "\\n"),
        subject_cn = element(split("=", element(split(",", cert.subject), 0)), 1),
        sha_1      = cert.sha1_fingerprint
      }
    }
  ]...)
  dns_ip_workspaces = {}
  template_dns = templatefile("${path.module}/config/dns.yaml",
    {
      env        = var.environment,
      edge_key   = akamai_edge_hostname.edge_hostname.edge_hostname,
      zone_auth  = join("\", \"", local.dns.zone_auth), //Create a set of strings for a dns_record target array
  })
  dns_records = yamldecode(local.template_dns).dns_records
}