variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) Desired name for the VPC Gateway Load Balancer Endpoint."
  type        = string
  nullable    = false
}

variable "service_name" {
  description = "(Required) The service name of the Gateway Load Balancer endpoint service. The service name is usually in the form `com.amazonaws.vpce.<region>.vpce-svc-<id>`."
  type        = string
  nullable    = false
}

variable "auto_accept" {
  description = "(Optional) Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account)."
  type        = bool
  default     = true
  nullable    = false
}

variable "vpc_id" {
  description = "(Required) The ID of the VPC in which the endpoint will be used."
  type        = string
  nullable    = false
}

variable "subnet_id" {
  description = "(Required) The ID of the subnet in which to create the endpoint network interface. A Gateway Load Balancer endpoint supports only one subnet in a single Availability Zone, and the subnet cannot be changed after creation."
  type        = string
  nullable    = false
}

variable "ip_address_type" {
  description = "(Optional) The type of IP addresses used by the subnet for the Gateway Load Balancer endpoint. The possible values are `IPv4`, `IPv6` and `DUALSTACK`. The value must be compatible with the IP address types supported by both the endpoint service and the subnet. Defaults to `IPv4`."
  type        = string
  default     = "IPv4"
  nullable    = false

  validation {
    condition     = contains(["IPv4", "IPv6", "DUALSTACK"], var.ip_address_type)
    error_message = "The possible values are `IPv4`, `IPv6` and `DUALSTACK`."
  }
}

variable "connection_notifications" {
  description = <<EOF
  (Optional) A list of configurations of Endpoint Connection Notifications for VPC Endpoint events. Each block of `connection_notifications` as defined below.
    (Required) `name` - The name of the configuration for connection notification. This value is only used internally within Terraform code.
    (Required) `sns_topic` - The Amazon Resource Name (ARN) of the SNS topic for the notifications.
    (Required) `events` - One or more endpoint events for which to receive notifications. Valid values are `Accept`, `Reject`, `Connect` and `Delete`.
  EOF
  type = list(object({
    name      = string
    sns_topic = string
    events    = set(string)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for notification in var.connection_notifications :
      alltrue([
        for event in notification.events :
        contains(["Accept", "Reject", "Connect", "Delete"], event)
      ])
    ])
    error_message = "Valid values for `events` of each notifications are `Accept`, `Reject`, `Connect` and `Delete`."
  }
}

variable "timeouts" {
  description = "(Optional) How long to wait for the endpoint to be created/updated/deleted."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default  = {}
  nullable = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
