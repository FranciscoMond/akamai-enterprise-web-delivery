data "tls_certificate" "cert_urls" {
  for_each = local.cert_urls
  url      = "https://${each.value}"
}