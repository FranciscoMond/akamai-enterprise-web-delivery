#Default Workspace Variables
variable "environment" {
  description = "Identifier for environment"
  type        = string
}

variable "foundation_tfcloud_organization_name" {
  description = "The unique name of the Terraform Cloud organization"
  type        = string
}

variable "foundation_tfcloud_workspace_name" {
  description = "The unique name of the Terraform Cloud workspace --- This variable is managed by Terraform."
  type        = string
}

variable "gcp_organization_id" {
  description = "Google Cloud organization Id --- This variable is managed by Terraform."
  type        = string
}

variable "parent_workspace" {
  description = "Name of parent TFC workspace"
  type        = string
}

variable "stage" {
  description = "Identifier for stage --- This variable is managed by Terraform."
  type        = string
}

variable "tfc_project_name" {
  description = "Name of TFC project where this workspace resides --- This variable is managed by Terraform."
  type        = string
}

variable "workspace" {
  description = "Name of current TFC workspace"
  type        = string
}

#Custom Workspace Variables
variable "rules_certs_pem" {
  description = "A list of certificates for pinning, keyed by a string"
  type = map(list(object({
    subjectCN       = string
    sha1Fingerprint = string
    pemEncodedCert  = string
  })))
}

variable "group" {
  type = object({
    akamai_parent_group_name = string
    akamai_group_prefix      = string
    emails                   = list(string)
    env                      = string
    tf_cloud_org             = string
  })
}

variable "dns" {
  type = object({
    dns_zone              = string
    edge_hostname         = string
    zone_auth             = list(string)
  })
}

variable "property" {
  type = object({
    product_id = string
    activation_stg = object({
      latest  = bool
      version = number
    })
    activation_prd = object({
      latest  = bool
      version = number
    })
    rules = map(object({
      origin-hostname = optional(string)
      origin-hostname2 = optional(string)
      origin-hostname-new = optional(string)
      hostnames       = optional(list(string))
      paths           = optional(string)
      origin-id       = optional(string)
      origin-id2       = optional(string)
      origin-id3       = optional(string)
    }))

  })
}

variable "cloudlet" {
  type = map(string)
}

variable "app-sec" {
  type = object({
    reputation_profile = map(string)
    waf_attack_group   = map(string)
    bot_category = map(object({
      action = string
    }))
    custom_bot_category = map(object({
      action = string
    }))
    detection_category      = any
    bot_management_settings = map(bool)
    rate_policies = map(object({
      threshold = object({
        burst = number
        avg   = number
      })
    }))
    rate_policy_actions = map(string)
    protections         = map(bool)
    config = object({
      penalty_box_action         = string
      match_type                 = string
      match_target_hosts         = list(string)
      slow_rate_action           = string
      slow_rate_threshold_rate   = number
      slow_rate_threshold_period = number
      custom_rule_action         = string
      ip_geo_mode                = string
      stg_version                = number
      prd_version                = number
    })
  })
}

variable "network_list" {
  type = object({
    bypass                    = list(string)
    google-central-us-1-ips   = list(string)
    google-west-europe-1-ips  = list(string)
    google-global-ips         = list(string)
    google-east-us-1-ips      = list(string)
    qa-testing-ips            = list(string)
    aws-ips                   = list(string)
  })
}

variable "datastreamSplunk" {
  type = object({
    dataset_fields = object({
      dataset_field_id = list(number)
    })
    stream_name   = string
    datastream_id = string
    destination = object({
      display_name          = string
      endpoint              = string
      event_collector_token = string
    })
  })
}

variable "include_datastream_behavior" {
  type        = bool
  description = "boolean to exclude datastream from rules for initial env creation"
  default     = true
}