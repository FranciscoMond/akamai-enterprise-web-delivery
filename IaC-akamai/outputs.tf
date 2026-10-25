output "akamai_group_id" {
  description = "ID of the Akamai group"
  value       = akamai_iam_group.akamai_group.id
}

output "property_activation_warnings" {
  value = akamai_property_activation.property_activation.warnings
}

output "url_certs" {
  value = merge([
    for cert_url_name, cert_url_data in data.tls_certificate.cert_urls : {
      for cert in cert_url_data.certificates :
      "${cert_url_name}_${cert.is_ca ? (cert.issuer == cert.subject ? "root" : "intermediate") : "server"}" => {
        issuer     = cert.issuer
        expiration = cert.not_after
        is_ca      = cert.is_ca
        subject_cn = element(split("=", element(split(",", cert.subject), 0)), 1),
        sha_1      = cert.sha1_fingerprint
      }
    }
  ]...)
}

output "datastreamSplunk_id" {
  value = akamai_datastream.splunk_datastream.id
}