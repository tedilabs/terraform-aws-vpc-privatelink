# vpc-service-network-endpoint

This module creates following resources.

- `aws_vpc_endpoint`
- `aws_vpc_endpoint_security_group_association`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.61.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | tedilabs/network/aws//modules/security-group | ~> 1.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_security_group_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the VPC Service Network Endpoint. | `string` | n/a | yes |
| <a name="input_service_network_arn"></a> [service\_network\_arn](#input\_service\_network\_arn) | (Required) The Amazon Resource Name (ARN) of the VPC Lattice service network to connect this VPC endpoint to. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) A list of subnet IDs in which to create endpoint network interfaces for the endpoint. Choose one subnet for each Availability Zone. For VPC Lattice services associated with the service network, the endpoint requires a contiguous `/28` IPv4 block (or `/80` IPv6 block) per Availability Zone. In a production environment, for high availability and resiliency, it is recommended to configure subnets in at least two Availability Zones. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) The ID of the VPC in which the endpoint will be used. | `string` | n/a | yes |
| <a name="input_default_security_group"></a> [default\_security\_group](#input\_default\_security\_group) | (Optional) The configuration of the default security group for the service network endpoint. `default_security_group` block as defined below.<br/>    (Optional) `enabled` - Whether to use the default security group. Defaults to `true`.<br/>    (Optional) `name` - The name of the default security group. If not provided, the endpoint name is used for the name of security group.<br/>    (Optional) `description` - The description of the default security group.<br/>    (Optional) `ingress_rules` - A list of ingress rules in a security group. You don't need to specify `protocol`, `from_port`, `to_port`. Just specify source information. Defaults to `[{ id = "default", ipv4_cidrs = ["0.0.0.0/0"] }]`. Each block of `ingress_rules` as defined below.<br/>      (Required) `id` - The ID of the ingress rule. This value is only used internally within Terraform code.<br/>      (Optional) `description` - The description of the rule.<br/>      (Optional) `protocol` - The protocol to match. Note that if `protocol` is set to `-1`, it translates to all protocols, all port ranges, and `from_port` and `to_port` values should not be defined. Defaults to `tcp`.<br/>      (Optional) `from_port` - The start of port range for the TCP protocols. Defaults to `443`.<br/>      (Optional) `to_port` - The end of port range for the TCP protocols. Defaults to `443`.<br/>      (Optional) `ipv4_cidrs` - The IPv4 network ranges to allow, in CIDR notation.<br/>      (Optional) `ipv6_cidrs` - The IPv6 network ranges to allow, in CIDR notation.<br/>      (Optional) `prefix_lists` - The prefix list IDs to allow.<br/>      (Optional) `security_groups` - The source security group IDs to allow.<br/>      (Optional) `self` - Whether the security group itself will be added as a source to this ingress rule. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string)<br/>    description = optional(string, "Managed by Terraform.")<br/>    ingress_rules = optional(<br/>      list(object({<br/>        id              = string<br/>        description     = optional(string, "Managed by Terraform.")<br/>        protocol        = optional(string, "tcp")<br/>        from_port       = optional(number, 443)<br/>        to_port         = optional(number, 443)<br/>        ipv4_cidrs      = optional(list(string), [])<br/>        ipv6_cidrs      = optional(list(string), [])<br/>        prefix_lists    = optional(list(string), [])<br/>        security_groups = optional(list(string), [])<br/>        self            = optional(bool, false)<br/>      })),<br/>      [{<br/>        id         = "default"<br/>        ipv4_cidrs = ["0.0.0.0/0"]<br/>      }]<br/>    )<br/>  })</pre> | `{}` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | (Optional) The type of IP addresses used by the subnets for the service network endpoint. The possible values are `IPv4`, `IPv6` and `DUALSTACK`. Defaults to `IPv4` | `string` | `"IPv4"` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_private_dns"></a> [private\_dns](#input\_private\_dns) | (Optional) The configuration of the private DNS settings for the service network endpoint. To use private DNS, the attributes `enableDnsHostnames` and `enableDnsSupport` must be enabled for the VPC. `private_dns` block as defined below.<br/>    (Optional) `enabled` - Whether to associate private hosted zones with the specified VPC. The private hosted zones contain record sets for the custom domain names of the services and resources in the service network, which resolve to the private IP addresses of the endpoint network interfaces in the VPC. Defaults to `false`. Changing this value forces a new endpoint to be created.<br/>    (Optional) `record_ip_type` - The type of DNS records created for the endpoint. Valid values are `IPv4`, `IPv6`, `DUALSTACK`, `SERVICE_DEFINED`. Defaults to `IPv4`.<br/>    (Optional) `preference` - The preference for which private domains have a private hosted zone created for and associated with the specified VPC. Valid values are `ALL_DOMAINS`, `VERIFIED_DOMAINS_ONLY`, `VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS` and `SPECIFIED_DOMAINS_ONLY`. Defaults to `ALL_DOMAINS`.<br/>    (Optional) `specified_domains` - A list of private domains to create private hosted zones for and associate with the specified VPC. Required if `preference` is `VERIFIED_DOMAINS_AND_SPECIFIED_DOMAINS` or `SPECIFIED_DOMAINS_ONLY`. In all other cases, this value must not be specified. A maximum of 10 domains can be specified. | <pre>object({<br/>    enabled           = optional(bool, false)<br/>    record_ip_type    = optional(string, "IPv4")<br/>    preference        = optional(string, "ALL_DOMAINS")<br/>    specified_domains = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (Optional) A list of security group IDs to associate with the endpoint. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the endpoint to be created/updated/deleted. | <pre>object({<br/>    create = optional(string, "10m")<br/>    update = optional(string, "10m")<br/>    delete = optional(string, "10m")<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the VPC endpoint. |
| <a name="output_default_security_group"></a> [default\_security\_group](#output\_default\_security\_group) | The default security group ID of the VPC endpoint. |
| <a name="output_dns_entries"></a> [dns\_entries](#output\_dns\_entries) | The DNS entries for the VPC Endpoint. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC endpoint. |
| <a name="output_ip_address_type"></a> [ip\_address\_type](#output\_ip\_address\_type) | The type of IP addresses used by the VPC endpoint. |
| <a name="output_name"></a> [name](#output\_name) | The VPC Service Network Endpoint name. |
| <a name="output_network_interfaces"></a> [network\_interfaces](#output\_network\_interfaces) | One or more network interfaces for the VPC Endpoint. |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | The Owner ID of the VPC endpoint. |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | The configuration of the private DNS settings for the VPC Endpoint. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_requester_managed"></a> [requester\_managed](#output\_requester\_managed) | Whether or not the VPC Endpoint is being managed by its service. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_security_groups"></a> [security\_groups](#output\_security\_groups) | A set of security group IDs which is assigned to the VPC endpoint. |
| <a name="output_service_network_arn"></a> [service\_network\_arn](#output\_service\_network\_arn) | The Amazon Resource Name (ARN) of the VPC Lattice service network of the VPC Service Network Endpoint. |
| <a name="output_state"></a> [state](#output\_state) | The state of the VPC endpoint. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | A list of subnet IDs in which endpoint network interfaces of the VPC endpoint are created. |
| <a name="output_type"></a> [type](#output\_type) | The type of the VPC endpoint. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC ID of the VPC endpoint. |
<!-- END_TF_DOCS -->
