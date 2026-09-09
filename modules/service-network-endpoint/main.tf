locals {
  metadata = {
    package = "terraform-aws-vpc-privatelink"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

locals {
  security_groups = concat(
    (var.default_security_group.enabled
      ? module.security_group[*].id
      : []
    ),
    var.security_groups
  )

  ip_address_types = {
    "IPv4"            = "ipv4"
    "IPv6"            = "ipv6"
    "DUALSTACK"       = "dualstack"
    "SERVICE_DEFINED" = "service-defined"
  }
}


###################################################
# Service Network Endpoint
###################################################

# INFO: Not supported attributes
# - `auto_accept` (Only applicable to endpoints connected to a VPC Endpoint Service)
# - `dns_options.private_dns_only_for_inbound_resolver_endpoint` (Only supported for `Interface` endpoint type)
# - `policy` (Only supported for `Gateway` and some `Interface` endpoint types)
# - `resource_configuration_arn` (Only supported for `Resource` endpoint type)
# - `route_table_ids` (Only supported for `Gateway` endpoint type)
# - `service_name` (Conflicts with `service_network_arn`)
# - `service_region` (Only supported for `Interface` endpoint type)
# - `subnet_configuration` (Not supported for `ServiceNetwork` endpoint type)
# INFO: Use a separate resource
# - `security_group_ids`
resource "aws_vpc_endpoint" "this" {
  region = var.region

  vpc_endpoint_type   = "ServiceNetwork"
  service_network_arn = var.service_network

  vpc_id          = var.vpc_id
  ip_address_type = local.ip_address_types[var.ip_address_type]
  subnet_ids      = var.subnets

  private_dns_enabled = var.private_dns.enabled

  dynamic "dns_options" {
    for_each = var.private_dns.enabled ? ["go"] : []

    content {
      dns_record_ip_type     = local.ip_address_types[var.private_dns.record_ip_type]
      private_dns_preference = var.private_dns.preference
      private_dns_specified_domains = (length(var.private_dns.specified_domains) > 0
        ? var.private_dns.specified_domains
        : null
      )
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Security Groups for Service Network Endpoint
###################################################

resource "aws_vpc_endpoint_security_group_association" "this" {
  count = length(local.security_groups)

  region = var.region

  vpc_endpoint_id   = aws_vpc_endpoint.this.id
  security_group_id = local.security_groups[count.index]

  replace_default_association = count.index == 0
}


###################################################
# Subnet Associations for Service Network Endpoint
###################################################

# INFO: Not support IP address allocation per subnet
# resource "aws_vpc_endpoint_subnet_association" "this" {
#   for_each = var.network_mapping
#
#   region = var.region
#
#   vpc_endpoint_id = aws_vpc_endpoint.this.id
#   subnet_id       = each.value.subnet
#
#   lifecycle {
#     precondition {
#       condition     = contains(local.available_az_ids, each.key)
#       error_message = "Availability zone ${each.key} is not available."
#     }
#   }
# }
