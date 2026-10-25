group = {
  "akamai_parent_group_name" : "MY_GROUP_NAME",
  "akamai_group_prefix" : "mydomain",
  "emails" : [
    "myemail@mydomain.com"
  ],
  "env" : "stg",
  "tf_cloud_org" : "TerraformGroup"
}
dns = {
  "dns_zone" : "mydomain.com",
  "edge_hostname" : "myzone.edgekey.net",
  "zone_auth" : []
}
property = {
  "product_id" : "prd_Fresca",
  "activation_stg" : {
    "latest" : true,
    "version" : 1
  },
  "activation_prd" : {
    "latest" : true,
    "version" : 1
  },
  "rules" : {
    "redirect-to-www" : {
      "hostnames" : [
        "mydomain.com",
        "www.mydomain.com"
      ]
    },
    "api" : {
      "origin-hostname" : "origin-api.mydomain.com",
      "hostnames" : [
        "api.mydomain.com"
      ]
    },
    "fonts" : {
      "hostnames" : [
        "mydomain.com",
        "*.mydomain.com"
      ],
    },
    "caching" : {
      "hostnames" : [
        "mydomain.com",
        "www.mydomain.com",
        "*.mydomain.com",
        "api.mydomain.com",
        "origin-api.mydomain.com"
      ],
    },
    "conditional-origin-group" : {}
  }
}
cloudlet = {
  "fr_path_qs" : "mydomainstage"
}
app-sec = {
  "reputation_profile" : {
    "Web Attackers (High Threat)" : "deny",
    "DoS Attackers (High Threat)" : "deny",
    "Scanning Tools (High Threat)" : "deny",
    "Web Attackers (Low Threat)" : "alert",
    "DoS Attackers (Low Threat)" : "alert",
    "Scanning Tools (Low Threat)" : "alert",
    "Web Scrapers (Low Threat)" : "alert",
    "Web Scrapers (High Threat)" : "deny"
  },
  "waf_attack_group" : {
    "OUTBOUND" : "none",
    "PLATFORM" : "deny",
    "RFI" : "deny",
    "LFI" : "deny",
    "CMD" : "deny",
    "XSS" : "deny",
    "SQL" : "deny",
    "PROTOCOL" : "deny",
    "WAT" : "deny",
    "POLICY" : "alert"
  },
  "bot_category" : {
    "Academic or Research Bots" : {
      "action" : "deny"
    },
    "Business Intelligence Bots" : {
      "action" : "deny"
    },
    "E-Commerce Search Engine Bots" : {
      "action" : "deny"
    },
    "Enterprise Data Aggregator Bots" : {
      "action" : "deny"
    },
    "Financial Account Aggregator Bots" : {
      "action" : "deny"
    },
    "Financial Services Bots" : {
      "action" : "deny"
    },
    "Job Search Engine Bots" : {
      "action" : "deny"
    },
    "Media or Entertainment Search Bots" : {
      "action" : "deny"
    },
    "News Aggregator Bots" : {
      "action" : "deny"
    },
    "Online Advertising Bots" : {
      "action" : "deny"
    },
    "RSS Feed Reader Bots" : {
      "action" : "deny"
    },
    "SEO, Analytics or Marketing Bots" : {
      "action" : "deny"
    },
    "Site Monitoring and Web Development Bots" : {
      "action" : "deny"
    },
    "Social Media or Blog Bots" : {
      "action" : "deny"
    },
    "Web Archiver Bots" : {
      "action" : "deny"
    },
    "Web Search Engine Bots" : {
      "action" : "deny"
    }
  },
  "detection_category" : {
    "Impersonators of Known Bots" : {
      "action" : "deny"
    },
    "Development Frameworks" : {
      "action" : "monitor"
    },
    "HTTP Libraries" : {
      "action" : "monitor"
    },
    "Web Services Libraries" : {
      "action" : "deny"
    },
    "Open Source Crawlers/Scraping Platforms" : {
      "action" : "deny"
    },
    "Headless Browsers/Automation Tools" : {
      "action" : "deny"
    },
    "Declared Bots (Keyword Match)" : {
      "action" : "deny"
    },
    "Aggressive Web Crawlers" : {
      "action" : "deny"
    },
    "Browser Impersonator" : {
      "action" : "monitor"
    },
    "Web Scraper Reputation" : {
      "action" : "monitor",
      "webScraperReputationSensitivity" : 4
    },
    "Cookie Integrity Failed" : {
      "action" : "deny"
    },
    "Session Validation" : {
      "action" : "deny",
      "sessionActivitySensitivity" : "MEDIUM"
    },
    "Client Disabled JavaScript (Noscript Triggered)" : {
      "action" : "monitor"
    },
    "JavaScript Fingerprint Anomaly" : {
      "action" : "monitor"
    },
    "JavaScript Fingerprint Not Received" : {
      "action" : "monitor"
    }
  },
  "bot_management_settings" : {
    "enableBotManagement" : true,
    "addAkamaiBotHeader" : false,
    "removeBotManagementCookies" : true,
    "thirdPartyProxyServiceInUse" : false,
    "enableActiveDetections" : true,
    "enableBrowserValidation" : true
  },
  "rate_policies" : {
    "origin-error" : {
      "threshold" : {
        "burst" : 8,
        "avg" : 5
      }
    },
    "page-view-requests" : {
      "threshold" : {
        "burst" : 18,
        "avg" : 12
      }
    },
    "post-page-requests" : {
      "threshold" : {
        "burst" : 5,
        "avg" : 3
      }
    }
  },
  "rate_policy_actions" : {
    "POST Page Requests" : "deny",
    "Origin Error" : "deny",
    "Page View Requests" : "deny"
  },
  "protections" : {
    "reputation" : true,
    "ip_geo" : true,
    "api" : false,
    "penalty_box" : true,
    "slow" : true,
    "rate" : true,
    "waf" : true
  },
  "config" : {
    "penalty_box_action" : "alert",
    "match_type" : "website",
    "match_target_hosts" : [
      "*.mydomain.com",
      "mydomain.com"
    ],
    "slow_rate_action" : "alert",
    "slow_rate_threshold_rate" : 10,
    "slow_rate_threshold_period" : 60,
    "custom_rule_action" : "none",
    "ip_geo_mode" : "block",
    "stg_version" : 1,
    "prd_version" : 1
  }
}
network_list = {
  "bypass" : [],
  "google-global-ips" : [
    "8.8.4.0/24",
    "8.8.8.0/24",
    "8.34.208.0/20",
    "8.35.192.0/20",
    "23.236.48.0/20",
    "23.251.128.0/19",
    "34.0.0.0/15",
    "34.2.0.0/16",
    "34.3.0.0/23",
    "34.3.3.0/24",
    "34.3.4.0/24",
    "34.3.8.0/21",
    "34.3.16.0/20",
    "34.3.32.0/19",
    "34.3.64.0/18",
    "34.4.0.0/14",
    "34.8.0.0/13",
    "34.16.0.0/12",
    "34.32.0.0/11",
    "34.64.0.0/10",
    "34.128.0.0/10",
    "35.184.0.0/13",
    "35.192.0.0/14",
    "35.196.0.0/15",
    "35.198.0.0/16",
    "35.199.0.0/17",
    "35.199.128.0/18",
    "35.200.0.0/13",
    "35.208.0.0/12",
    "35.224.0.0/12",
    "35.240.0.0/13",
    "57.140.192.0/18",
    "64.15.112.0/20",
    "64.233.160.0/19",
    "66.22.228.0/23",
    "66.102.0.0/20",
    "66.249.64.0/19",
    "70.32.128.0/19",
    "72.14.192.0/18",
    "74.114.24.0/21",
    "74.125.0.0/16",
    "104.154.0.0/15",
    "104.196.0.0/14",
    "104.237.160.0/19",
    "107.167.160.0/19",
    "107.178.192.0/18",
    "108.59.80.0/20",
    "108.170.192.0/18",
    "108.177.0.0/17",
    "130.211.0.0/16",
    "136.22.160.0/20",
    "136.22.176.0/21",
    "136.22.184.0/23",
    "136.22.186.0/24",
    "136.124.0.0/15",
    "142.250.0.0/15",
    "146.148.0.0/17",
    "152.65.208.0/22",
    "152.65.214.0/23",
    "152.65.218.0/23",
    "152.65.222.0/23",
    "152.65.224.0/19",
    "162.120.128.0/17",
    "162.216.148.0/22",
    "162.222.176.0/21",
    "172.110.32.0/21",
    "172.217.0.0/16",
    "172.253.0.0/16",
    "173.194.0.0/16",
    "173.255.112.0/20",
    "192.104.160.0/23",
    "192.158.28.0/22",
    "192.178.0.0/15",
    "193.186.4.0/24",
    "199.36.154.0/23",
    "199.36.156.0/24",
    "199.192.112.0/22",
    "199.223.232.0/21",
    "207.223.160.0/20",
    "208.65.152.0/22",
    "208.68.108.0/22",
    "208.81.188.0/22",
    "208.117.224.0/19",
    "209.85.128.0/17",
    "216.58.192.0/19",
    "216.73.80.0/20",
    "216.239.32.0/19",
    "216.252.220.0/22",
    "2001:4860::/32",
    "2404:6800::/32",
    "2404:f340::/32",
    "2600:1900::/28",
    "2605:ef80::/32",
    "2606:40::/32",
    "2606:73c0::/32",
    "2607:1c0:241:40::/60",
    "2607:1c0:300::/40",
    "2607:f8b0::/32",
    "2620:11a:a000::/40",
    "2620:120:e000::/40",
    "2800:3f0::/32",
    "2a00:1450::/32",
    "2c0f:fb50::/32"
  ],
  "google-east-us-1-ips" : []
}
datastreamSplunk = {
  "dataset_fields" : {
    "dataset_field_id" : [
      999,
      1000,
      1002,
      1005,
      1006,
      1008,
      1009,
      1011,
      1012,
      1013,
      1014,
      1015,
      1016,
      1017,
      1019,
      1023,
      1031,
      1032,
      1037,
      1033,
      1066,
      1068,
      1100,
      1102,
      1103,
      2001,
      2002,
      2003,
      2004,
      2005,
      2006,
      2007,
      2008,
      2009,
      2010,
      2012,
      2013,
      2014,
      2019,
      2020,
      2021,
      2022,
      2023,
      2024,
      2025,
      2026,
      2027,
      2028,
      2050,
      2052,
      2053,
      2060,
      2061,
      2084,
      3000,
      3001,
      3011
    ]
  },
  "stream_name" : "Splunk_DataStream",
  "destination" : {
    "display_name" : "Splunk_DataStream",
    "endpoint" : "https://splunkcloud.myendpoint.com/services/collector/raw",
    "event_collector_token" : "00000000-0000-0000-0000-000000000000"
  },
  "datastream_id" : "00000"
}
datastreamDynatrace = {
  "dataset_fields" : {
    "dataset_field_id" : [
      999,
      1000,
      1002,
      1005,
      1006,
      1008,
      1009,
      1011,
      1012,
      1013,
      1014,
      1015,
      1016,
      1017,
      1019,
      1023,
      1031,
      1032,
      1037,
      1033,
      1066,
      1068,
      1100,
      1102,
      1103,
      2001,
      2002,
      2003,
      2004,
      2005,
      2006,
      2007,
      2008,
      2009,
      2010,
      2012,
      2013,
      2014,
      2019,
      2020,
      2021,
      2022,
      2023,
      2024,
      2025,
      2026,
      2027,
      2028,
      2050,
      2052,
      2053,
      2060,
      2061,
      2084,
      3000,
      3001,
      3011
    ]
  }
}

include_datastream_behavior = true