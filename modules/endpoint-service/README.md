# endpoint-service

This module creates following resources.

- `aws_vpc_endpoint_service`
- `aws_vpc_endpoint_service_allowed_principal` (optional)
- `aws_vpc_endpoint_connection_notification` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |
| <a name="requirement_telemetry"></a> [telemetry](#requirement\_telemetry) | >= 0.1.1 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.12 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_vpc_endpoint_connection_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_connection_notification) | resource |
| [aws_vpc_endpoint_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service) | resource |
| [aws_vpc_endpoint_service_allowed_principal.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service_allowed_principal) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_load_balancers"></a> [load\_balancers](#input\_load\_balancers) | (Required) A list of Amazon Resource Names of Network Load Balancers or Gateway Load Balancers for the endpoint service. | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the VPC Endpoint Service. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | (Required) A load balancer type for the VPC Endpoint Service. Valid values are `GWLB` and `NLB`. | `string` | n/a | yes |
| <a name="input_acceptance_required"></a> [acceptance\_required](#input\_acceptance\_required) | (Optional) Whether or not VPC endpoint connection requests to the service must be accepted by the service owner. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_allowed_principals"></a> [allowed\_principals](#input\_allowed\_principals) | (Optional) A list of the ARNs of principal to allow to discover a VPC endpoint service. | `list(string)` | `[]` | no |
| <a name="input_connection_notifications"></a> [connection\_notifications](#input\_connection\_notifications) | (Optional) A list of configurations of Endpoint Connection Notifications for VPC Endpoint Service events. Each block of `connection_notifications` as defined below.<br/>    (Required) `name` - The name of the configuration for connection notification. This value is only used internally within Terraform code.<br/>    (Required) `sns_topic` - The Amazon Resource Name (ARN) of the SNS topic for the notifications.<br/>    (Required) `events` - One or more endpoint events for which to receive notifications. Valid values are `Accept`, `Reject`, `Connect` and `Delete`. | <pre>list(object({<br/>    name      = string<br/>    sns_topic = string<br/>    events    = set(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_private_domain"></a> [private\_domain](#input\_private\_domain) | (Optional) The private domain name for the service. This option allows users of endpoints to use the specified private DNS name for access the service from their VPCs. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_supported_ip_address_types"></a> [supported\_ip\_address\_types](#input\_supported\_ip\_address\_types) | (Optional) The supported IP address types. Valid values are `IPv4` and `IPv6`. | `set(string)` | `[]` | no |
| <a name="input_supported_regions"></a> [supported\_regions](#input\_supported\_regions) | (Optional) A set of supported AWS regions from which service consumers can access the service. | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_telemetry"></a> [telemetry](#input\_telemetry) | (Optional) A configuration to collect telemetry data for the module. This is used to improve the module and its features. The data collected is anonymous and does not contain any sensitive information. The default configuration enables telemetry collection for machine, network, git, github, github actions, terraform, and toolchain. You can disable telemetry collection by setting `enabled` to `false`. `telemetry` block as defined below.<br/>    (Optional) `enabled` - Whether to enable telemetry collection. Default is `true`.<br/>    (Optional) `capture_machine` - Whether to capture machine information. Default is `true`.<br/>    (Optional) `capture_network` - Whether to capture network information. Default is `true`.<br/>    (Optional) `capture_git` - Whether to capture git information. Default is `true`.<br/>    (Optional) `capture_github` - Whether to capture GitHub information. Default is `true`.<br/>    (Optional) `capture_github_actions` - Whether to capture GitHub Actions information. Default is `true`.<br/>    (Optional) `capture_terraform` - Whether to capture Terraform information. Default is `true`.<br/>    (Optional) `capture_toolchain` - Whether to capture toolchain information. Default is `true`. | <pre>object({<br/>    enabled = optional(bool, true)<br/><br/>    capture_machine        = optional(bool, true)<br/>    capture_network        = optional(bool, true)<br/>    capture_git            = optional(bool, true)<br/>    capture_github         = optional(bool, true)<br/>    capture_github_actions = optional(bool, true)<br/>    capture_terraform      = optional(bool, true)<br/>    capture_toolchain      = optional(bool, true)<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_allowed_principals"></a> [allowed\_principals](#output\_allowed\_principals) | A list of the ARNs of allowed principals to discover a VPC endpoint service. |
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the VPC endpoint service. |
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | The Availability Zones in which the service is available. |
| <a name="output_connection_notifications"></a> [connection\_notifications](#output\_connection\_notifications) | A list of Endpoint Connection Notifications for VPC Endpoint Service events. |
| <a name="output_domain_names"></a> [domain\_names](#output\_domain\_names) | The DNS names for the service. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC endpoint service. |
| <a name="output_load_balancers"></a> [load\_balancers](#output\_load\_balancers) | A list of ARNs of the load balancers for the VPC Endpoint Service. |
| <a name="output_manages_vpc_endpoints"></a> [manages\_vpc\_endpoints](#output\_manages\_vpc\_endpoints) | Whether or not the service manages its VPC endpoints |
| <a name="output_name"></a> [name](#output\_name) | The VPC Endpoint Service name. |
| <a name="output_private_domain"></a> [private\_domain](#output\_private\_domain) | The private DNS name for the service. |
| <a name="output_private_domain_configurations"></a> [private\_domain\_configurations](#output\_private\_domain\_configurations) | List of objects containing information about the endpoint service private DNS name configuration. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The service name. |
| <a name="output_service_type"></a> [service\_type](#output\_service\_type) | The service type, `Gateway` or `Interface`. |
| <a name="output_state"></a> [state](#output\_state) | The state of the VPC endpoint service. |
| <a name="output_supported_ip_address_types"></a> [supported\_ip\_address\_types](#output\_supported\_ip\_address\_types) | The supported IP address types. |
| <a name="output_supported_regions"></a> [supported\_regions](#output\_supported\_regions) | The supported AWS regions for the VPC endpoint service. |
| <a name="output_type"></a> [type](#output\_type) | A load balancer type for the VPC Endpoint Service. |
<!-- END_TF_DOCS -->
