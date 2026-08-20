# vpc-gateway-load-balancer-endpoint

This module creates following resources.

- `aws_vpc_endpoint`
- `aws_vpc_endpoint_connection_notification` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.61.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_connection_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_connection_notification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the VPC Gateway Load Balancer Endpoint. | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | (Required) The service name of the Gateway Load Balancer endpoint service. The service name is usually in the form `com.amazonaws.vpce.<region>.vpce-svc-<id>`. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The ID of the subnet in which to create the endpoint network interface. A Gateway Load Balancer endpoint supports only one subnet in a single Availability Zone, and the subnet cannot be changed after creation. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) The ID of the VPC in which the endpoint will be used. | `string` | n/a | yes |
| <a name="input_auto_accept"></a> [auto\_accept](#input\_auto\_accept) | (Optional) Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account). | `bool` | `true` | no |
| <a name="input_connection_notifications"></a> [connection\_notifications](#input\_connection\_notifications) | (Optional) A list of configurations of Endpoint Connection Notifications for VPC Endpoint events. Each block of `connection_notifications` as defined below.<br/>    (Required) `name` - The name of the configuration for connection notification. This value is only used internally within Terraform code.<br/>    (Required) `sns_topic` - The Amazon Resource Name (ARN) of the SNS topic for the notifications.<br/>    (Required) `events` - One or more endpoint events for which to receive notifications. Valid values are `Accept`, `Reject`, `Connect` and `Delete`. | <pre>list(object({<br/>    name      = string<br/>    sns_topic = string<br/>    events    = set(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | (Optional) The type of IP addresses used by the subnet for the Gateway Load Balancer endpoint. The possible values are `IPv4`, `IPv6` and `DUALSTACK`. The value must be compatible with the IP address types supported by both the endpoint service and the subnet. Defaults to `IPv4`. | `string` | `"IPv4"` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the endpoint to be created/updated/deleted. | <pre>object({<br/>    create = optional(string, "10m")<br/>    update = optional(string, "10m")<br/>    delete = optional(string, "10m")<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the VPC endpoint. |
| <a name="output_connection_notifications"></a> [connection\_notifications](#output\_connection\_notifications) | A list of Endpoint Connection Notifications for VPC Endpoint events. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC endpoint. |
| <a name="output_ip_address_type"></a> [ip\_address\_type](#output\_ip\_address\_type) | The type of IP addresses used by the VPC endpoint. |
| <a name="output_name"></a> [name](#output\_name) | The VPC Gateway Load Balancer Endpoint name. |
| <a name="output_network_interfaces"></a> [network\_interfaces](#output\_network\_interfaces) | One or more network interfaces for the VPC Endpoint. |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | The owner ID of the VPC endpoint. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_requester_managed"></a> [requester\_managed](#output\_requester\_managed) | Whether or not the VPC Endpoint is being managed by its service. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The service name of the VPC Gateway Load Balancer Endpoint. |
| <a name="output_state"></a> [state](#output\_state) | The state of the VPC endpoint. |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | The subnet ID of the endpoint network interface for the VPC endpoint. |
| <a name="output_type"></a> [type](#output\_type) | The type of the VPC endpoint. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC ID of the VPC endpoint. |
<!-- END_TF_DOCS -->
