terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = "9.0.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}