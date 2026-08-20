variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) Desired name for the VPC Service Network Endpoint."
  type        = string
  nullable    = false
}

variable "service_network_arn" {
  description = "(Required) The Amazon Resource Name (ARN) of the VPC Lattice service network to connect this VPC endpoint to."
  type        = string
  nullable    = false
}

variable "vpc_id" {
  description = "(Required) The ID of the VPC in which the endpoint will be used."
  type        = string
  nullable    = false
}

variable "subnets" {
  description = "(Required) A list of subnet IDs in which to create endpoint network interfaces for the endpoint. Choose one subnet for each Availability Zone. For VPC Lattice services associated with the service network, the endpoint requires a contiguous `/28` IPv4 block (or `/80` IPv6 block) per Availability Zone. In a production environment, for high availability and resiliency, it is recommended to configure subnets in at least two Availability Zones."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.subnets) > 0
    error_message = "At least one subnet is required for the service network endpoint."
  }
}

variable "ip_address_type" {
  description = "(Optional) The type of IP addresses used by the subnets for the service network endpoint. The possible values are `IPv4`, `IPv6` and `DUALSTACK`. Defaults to `IPv4`"
  type        = string
  default     = "IPv4"
  nullable    = false

  validation {
    condition     = contains(["IPv4", "IPv6", "DUALSTACK"], var.ip_address_type)
    error_message = "The possible values are `IPv4`, `IPv6` and `DUALSTACK`."
  }
}

variable "private_dns" {
  description = <<EOF
  (Optional) The configuration of the private DNS settings for the service network endpoint. To use private DNS, the attributes `enableDnsHostnames` and `enableDnsSupport` must be enabled for the VPC. `private_dns` block as defined below.
    (Optional) `enabled` - Whether to associate private hosted zones with the specified VPC. The private hosted zones contain record sets for the custom domain names of the services and resources in the service network, which resolve to the private IP addresses of the endpoint network interfaces in the VPC. Defaults to `false`. Changing this value forces a new endpoint to be created.
    (Optional) `record_ip_type` - The type of DNS records created for the endpoint. Valid values are `IPv4`, `IPv6`, `DUALSTACK`, `SERVICE_DEFINED`. Defaults to `IPv4`.
    (Optional) `preference` - The preference for which private domains have a private hosted zone created for and associated with the specified VPC. Valid values are `ALL_DOMAINS`, `VERIFIED_DOMAINS_ONLY`, `VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS` and `SPECIFIED_DOMAINS_ONLY`. Defaults to `ALL_DOMAINS`.
    (Optional) `specified_domains` - A list of private domains to create private hosted zones for and associate with the specified VPC. Required if `preference` is `VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS` or `SPECIFIED_DOMAINS_ONLY`. In all other cases, this value must not be specified. A maximum of 10 domains can be specified.
  EOF
  type = object({
    enabled           = optional(bool, false)
    record_ip_type    = optional(string, "IPv4")
    preference        = optional(string, "ALL_DOMAINS")
    specified_domains = optional(list(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["IPv4", "IPv6", "DUALSTACK", "SERVICE_DEFINED"], var.private_dns.record_ip_type)
    error_message = "Valid values for `record_ip_type` are `IPv4`, `IPv6`, `DUALSTACK` and `SERVICE_DEFINED`."
  }
  validation {
    condition     = contains(["ALL_DOMAINS", "VERIFIED_DOMAINS_ONLY", "VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS", "SPECIFIED_DOMAINS_ONLY"], var.private_dns.preference)
    error_message = "Valid values for `preference` are `ALL_DOMAINS`, `VERIFIED_DOMAINS_ONLY`, `VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS` and `SPECIFIED_DOMAINS_ONLY`."
  }
  validation {
    condition = (contains(["VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS", "SPECIFIED_DOMAINS_ONLY"], var.private_dns.preference)
      ? length(var.private_dns.specified_domains) > 0
      : length(var.private_dns.specified_domains) == 0
    )
    error_message = "`specified_domains` must be specified only if `preference` is `VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS` or `SPECIFIED_DOMAINS_ONLY`."
  }
  validation {
    condition     = length(var.private_dns.specified_domains) <= 10
    error_message = "A maximum of 10 domains can be specified for `specified_domains`."
  }
}

variable "default_security_group" {
  description = <<EOF
  (Optional) The configuration of the default security group for the service network endpoint. `default_security_group` block as defined below.
    (Optional) `enabled` - Whether to use the default security group. Defaults to `true`.
    (Optional) `name` - The name of the default security group. If not provided, the endpoint name is used for the name of security group.
    (Optional) `description` - The description of the default security group.
    (Optional) `ingress_rules` - A list of ingress rules in a security group. You don't need to specify `protocol`, `from_port`, `to_port`. Just specify source information. Defaults to `[{ id = "default", ipv4_cidrs = ["0.0.0.0/0"] }]`. Each block of `ingress_rules` as defined below.
      (Required) `id` - The ID of the ingress rule. This value is only used internally within Terraform code.
      (Optional) `description` - The description of the rule.
      (Optional) `protocol` - The protocol to match. Note that if `protocol` is set to `-1`, it translates to all protocols, all port ranges, and `from_port` and `to_port` values should not be defined. Defaults to `tcp`.
      (Optional) `from_port` - The start of port range for the TCP protocols. Defaults to `443`.
      (Optional) `to_port` - The end of port range for the TCP protocols. Defaults to `443`.
      (Optional) `ipv4_cidrs` - The IPv4 network ranges to allow, in CIDR notation.
      (Optional) `ipv6_cidrs` - The IPv6 network ranges to allow, in CIDR notation.
      (Optional) `prefix_lists` - The prefix list IDs to allow.
      (Optional) `security_groups` - The source security group IDs to allow.
      (Optional) `self` - Whether the security group itself will be added as a source to this ingress rule.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    description = optional(string, "Managed by Terraform.")
    ingress_rules = optional(
      list(object({
        id              = string
        description     = optional(string, "Managed by Terraform.")
        protocol        = optional(string, "tcp")
        from_port       = optional(number, 443)
        to_port         = optional(number, 443)
        ipv4_cidrs      = optional(list(string), [])
        ipv6_cidrs      = optional(list(string), [])
        prefix_lists    = optional(list(string), [])
        security_groups = optional(list(string), [])
        self            = optional(bool, false)
      })),
      [{
        id         = "default"
        ipv4_cidrs = ["0.0.0.0/0"]
      }]
    )
  })
  default  = {}
  nullable = false
}

variable "security_groups" {
  description = "(Optional) A list of security group IDs to associate with the endpoint."
  type        = list(string)
  default     = []
  nullable    = false
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
