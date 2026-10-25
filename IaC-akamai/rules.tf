data "akamai_property_rules_builder" "default_rule" {
  rules_v2025_01_13 {
    name      = "default"
    is_secure = true
    comments  = "The Default rule contains behaviors in the default rule apply to all requests for the property hostnames unless another rule overrides these settings."
    behavior {
      origin {
        origin_type                   = "CUSTOMER"
        hostname                      = "origin.mydomain.com"
        forward_host_header           = "REQUEST_HOST_HEADER"
        cache_key_hostname            = "ORIGIN_HOSTNAME"
        compress                      = true
        enable_true_client_ip         = true
        http_port                     = 80
        https_port                    = 443
        verification_mode             = "CUSTOM"
        custom_valid_cn_values        = ["{{Origin Hostname}}", "{{Forward Host Header}}"]
        origin_certs_to_honor         = "CUSTOM_CERTIFICATES"
        true_client_ip_client_setting = false
        true_client_ip_header         = "True-Client-IP"
        origin_sni                    = true
        min_tls_version               = "DYNAMIC"
        custom_certificates {}
      }
    }
    behavior {
      forward_rewrite {
        enabled          = true
        is_shared_policy = false
        cloudlet_policy {
          id   = akamai_cloudlets_policy.forward_rewrite_policy.id
          name = akamai_cloudlets_policy.forward_rewrite_policy.name
        }
      }
    }
    behavior {
      edge_redirector {
        enabled          = true
        is_shared_policy = false
        cloudlet_policy {
          id   = akamai_cloudlets_policy.edge_redirector_policy.id
          name = akamai_cloudlets_policy.edge_redirector_policy.name
        }
      }
    }
    behavior {
      tiered_distribution {
        enabled = false
      }
    }
    behavior {
      sure_route {
        enable_custom_key = false
        enabled           = true
        force_ssl_forward = false
        race_stat_ttl     = "30m"
        test_object_url   = "/akamai/sureroute-test-object.html"
        to_host_status    = "INCOMING_HH"
        type              = "CUSTOM_MAP"
      }
    }
    behavior {
      site_shield {
        ssmap {
          value = var.environment != "prod" ? "s0000.akamaiedge.net" : "prod_ss_map_placeholder"
        }
      }
    }
    #When creating a new environment, this datastream section needs to be commented. This is due a 2 step procedure.
    dynamic "behavior" {
      for_each = var.include_datastream_behavior ? [1] : []
      content {
        datastream {
          stream_type         = "LOG"
          log_stream_title    = ""
          log_stream_name     = [local.datastreamSplunk.datastream_id]
          log_enabled         = true
          sampling_percentage = 100
        }
      }
    }
    behavior {
      cp_code {
        value {
          id   = akamai_cp_code.cp_code.id
          name = akamai_cp_code.cp_code.name
        }
      }
    }
    variable {
      name        = "PMUSER_ENVIRONMENT"
      value       = "none"
      description = "Environment"
      hidden      = false
      sensitive   = false
    }
    variable {
      name        = "PMUSER_ORIGIN"
      value       = "false"
      description = "Origin Header"
      hidden      = true
      sensitive   = false
    }
    variable {
      name        = "PMUSER_DEBUG_RULE"
      value       = "NoRule"
      description = "Debug Purposes"
      hidden      = false
      sensitive   = false
    }
    variable {
      name        = "PMUSER_LANGUAGE"
      value       = "en"
      description = "Default language by country code"
      hidden      = true
      sensitive   = false
    }
    children = [
      #Default rules that come with the akamai property
      templatefile("${path.module}/config/property-rules/augment-insights.json", {
        cp_id   = akamai_cp_code.cp_code.id,
        cp_name = akamai_cp_code.cp_code.name
      }),
      templatefile("${path.module}/config/property-rules/last-mile-acceleration.json", {}),
      templatefile("${path.module}/config/property-rules/accelerate-delivery.json", {}),
      templatefile("${path.module}/config/property-rules/strengthen-security.json", {}),
      templatefile("${path.module}/config/property-rules/increase-availability.json", {}),
      templatefile("${path.module}/config/property-rules/caching.json", {
        caching_rules = local.property.rules.caching
      }),
      templatefile("${path.module}/config/property-rules/fonts.json", {
        fonts_rules = local.property.rules.fonts
      }),
      templatefile("${path.module}/config/property-rules/cors.json", {}),
      templatefile("${path.module}/config/property-rules/cors-api.json", {}),
      templatefile("${path.module}/config/property-rules/cors-api-headers.json", {}),
      templatefile("${path.module}/config/property-rules/x-content-type-options.json", {}),
      templatefile("${path.module}/config/property-rules/conditional-origin-group.json", {})
    ]
  }
}