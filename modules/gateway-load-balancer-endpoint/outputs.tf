output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_vpc_endpoint.this.region
}

output "name" {
  description = "The VPC Gateway Load Balancer Endpoint name."
  value       = var.name
}

output "service_name" {
  description = "The service name of the VPC Gateway Load Balancer Endpoint."
  value       = aws_vpc_endpoint.this.service_name
}

output "id" {
  description = "The ID of the VPC endpoint."
  value       = aws_vpc_endpoint.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the VPC endpoint."
  value       = aws_vpc_endpoint.this.arn
}

output "owner_id" {
  description = "The owner ID of the VPC endpoint."
  value       = aws_vpc_endpoint.this.owner_id
}

output "type" {
  description = "The type of the VPC endpoint."
  value       = "GATEWAY_LOAD_BALANCER"
}

output "state" {
  description = "The state of the VPC endpoint."
  value       = upper(aws_vpc_endpoint.this.state)
}

output "requester_managed" {
  description = "Whether or not the VPC Endpoint is being managed by its service."
  value       = aws_vpc_endpoint.this.requester_managed
}

output "vpc_id" {
  description = "The VPC ID of the VPC endpoint."
  value       = aws_vpc_endpoint.this.vpc_id
}

output "subnet_id" {
  description = "The subnet ID of the endpoint network interface for the VPC endpoint."
  value       = one(aws_vpc_endpoint.this.subnet_ids)
}

output "ip_address_type" {
  description = "The type of IP addresses used by the VPC endpoint."
  value       = var.ip_address_type
}

output "network_interfaces" {
  description = "One or more network interfaces for the VPC Endpoint."
  value       = aws_vpc_endpoint.this.network_interface_ids
}

output "connection_notifications" {
  description = <<EOF
  A list of Endpoint Connection Notifications for VPC Endpoint events.
  EOF
  value = {
    for name, notification in aws_vpc_endpoint_connection_notification.this :
    name => {
      id        = notification.id
      state     = notification.state
      events    = notification.connection_events
      sns_topic = notification.connection_notification_arn
    }
  }
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}

# output "debug" {
#   value = {
#     for k, v in aws_vpc_endpoint.this :
#     k => v
#     if !contains(["tags_all", "timeouts", "id", "arn", "region", "service_name", "subnet_ids", "vpc_id", "vpc_endpoint_type", "tags", "state", "network_interface_ids", "ip_address_type", "auto_accept", "owner_id", "requester_managed"], k)
#   }
# }
