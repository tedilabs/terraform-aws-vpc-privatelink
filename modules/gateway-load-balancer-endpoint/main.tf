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
  ip_address_types = {
    "IPv4"      = "ipv4"
    "IPv6"      = "ipv6"
    "DUALSTACK" = "dualstack"
  }
}


###################################################
# Gateway Load Balancer Endpoint
###################################################

# INFO: Not supported attributes
# - `dns_options`
# - `policy`
# - `private_dns_enabled`
# - `resource_configuration_arn`
# - `route_table_ids`
# - `security_group_ids`
# - `service_network_arn`
# - `service_region`
# - `subnet_configuration`
resource "aws_vpc_endpoint" "this" {
  region = var.region

  vpc_endpoint_type = "GatewayLoadBalancer"
  service_name      = var.service_name
  auto_accept       = var.auto_accept

  vpc_id          = var.vpc_id
  ip_address_type = local.ip_address_types[var.ip_address_type]
  subnet_ids      = [var.subnet_id]

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
# Connection Notifications
###################################################

# INFO: Not supported attributes
# - `vpc_endpoint_service_id`
resource "aws_vpc_endpoint_connection_notification" "this" {
  for_each = {
    for config in var.connection_notifications :
    config.name => config
  }

  region = var.region

  vpc_endpoint_id = aws_vpc_endpoint.this.id

  connection_notification_arn = each.value.sns_topic
  connection_events           = each.value.events
}
