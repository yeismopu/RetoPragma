resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "fd-ecommerce-profile"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}
resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "fd-ecommerce-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}
resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = "fd-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  health_probe {
    interval_in_seconds = 30
    path                = "/health"
    protocol            = "Https"
    request_type        = "GET"
  }

  load_balancing {
    sample_size                = 4
    successful_samples_required = 3
  }
}
resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  name                          = "aks-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  enabled            = true
  host_name          = azurerm_public_ip.ingress_pip.fqdn
  http_port          = 80
  https_port         = 443
  origin_host_header = azurerm_public_ip.ingress_pip.fqdn
  certificate_name_check_enabled  = false
  priority           = 1
  weight             = 1000
}
resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "fd-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fd_origin.id]

  supported_protocols = ["Http", "Https"]
  patterns_to_match   = ["/*"]
  forwarding_protocol = "HttpsOnly"
}

resource "azurerm_cdn_frontdoor_firewall_policy" "fd_waf" {
  name                = "fdWafPolicy"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
  mode                = "Prevention"

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
    action  = "Block"
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "fd_security_policy" {
  name                     = "fdSecurityPolicy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.fd_waf.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}