output "akamai_group_id" {
  description = "ID of the Akamai group"
  value       = module.project_akamai.akamai_group_id
}

output "property_activation_warnings" {
  value = module.project_akamai.property_activation_warnings
}

output "pem_certs" {
  value = {
    for cert_name, cert_data in data.tls_certificate.cert : cert_name => {
      issuer     = cert_data.certificates[0].issuer
      expiration = cert_data.certificates[0].not_after
      is_ca      = cert_data.certificates[0].is_ca
      subject_cn = element(split("=", cert_data.certificates[0].subject), 1),
      sha_1      = cert_data.certificates[0].sha1_fingerprint
    }
  }
}

output "url_certs" {
  value = module.project_akamai.url_certs
}

output "datastreamSplunk_id" {
  value = module.project_akamai.datastreamSplunk_id
}