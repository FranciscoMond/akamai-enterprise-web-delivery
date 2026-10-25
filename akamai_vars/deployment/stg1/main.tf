locals {
  # Stores all cert key name, pem value pairs
  # This will be used to loop through every pem value to retrieve the cert details required for cert pinning
  cert_pems = {
    "wildcard" : var.wildcard_pem,
    "san" : var.san_pem
  }
  # Creates a new cert map, that parses and prepares: pem string, subjectCN, and sha_1 
  # In a manner that's required to template the rules json for property consumption
  processed_certs = {
    for cert_name, cert_data in data.tls_certificate.cert : cert_name => {
      pem        = cert_data.certificates[0].cert_pem,
      subject_cn = element(split("=", cert_data.certificates[0].subject), 1),
      sha_1      = cert_data.certificates[0].sha1_fingerprint
    }
  }
}

module "project_akamai" {
  source                               = "app.terraform.io/MYSITE/project-akamai/mydomain"
  version                              = "7.7.7" 
  environment                          = var.environment
  foundation_tfcloud_organization_name = var.foundation_tfcloud_organization_name
  foundation_tfcloud_workspace_name    = var.foundation_tfcloud_workspace_name
  parent_workspace                     = var.parent_workspace
  stage                                = var.stage
  tfc_project_name                     = var.tfc_project_name
  workspace                            = var.workspace
  dns                                  = var.dns
  group                                = var.group
  property                             = var.property
  cloudlet                             = var.cloudlet
  app-sec                              = var.app-sec
  network_list                         = var.network_list
  datastreamSplunk                     = var.datastreamSplunk
  # Set this boolean to false if creating a new environment
  # Most create a secondary PR reverting this to true, to include the behavior once datastream has been created
  include_datastream_behavior = var.include_datastream_behavior
  rules_certs_pem = {
    "api-custom-cert" : [
      {
        "subjectCN" : "${local.processed_certs.wildcard.subject_cn}",
        "sha1Fingerprint" : "${local.processed_certs.wildcard.sha_1}",
        "pemEncodedCert" : "${local.processed_certs.wildcard.pem}"
      }
    ]
  }
}

data "tls_certificate" "cert" {
  for_each = local.cert_pems
  # Modifies the pem single line string, into a PEM file format for tls_cert consumption
  # Replaces "\n" with actual newlines
  content = replace(each.value, "\\n", "\n")
}