# terraform-aws-vpc-privatelink

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tedilabs/terraform-aws-vpc-privatelink?color=blue&sort=semver&style=flat-square)
![GitHub](https://img.shields.io/github/license/tedilabs/terraform-aws-vpc-privatelink?color=blue&style=flat-square)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

Terraform module which creates VPC PrivateLink related resources on AWS.

- [endpoint-service](./modules/endpoint-service)
- [gateway-endpoint](./modules/gateway-endpoint)
- [interface-endpoint](./modules/interface-endpoint)


## Target AWS Services

Terraform Modules from [this package](https://github.com/tedilabs/terraform-aws-vpc-privatelink) were written to manage the following AWS Services with Terraform.

- **AWS VPC (Virtual Private Cloud)**
  - PrivateLink
    - Endpoint Service
    - Gateway Endpoint
    - Gateway Load Balancer Endpoint
    - Interface Endpoint
    - VPC Lattice Resource Endpoint
    - VPC Lattice Service Network Endpoint


## Examples

### VPC PrivateLink

- [gateway-endpoint-simple](./examples/gateway-endpoint-simple)
- [interface-endpoint-simple](./examples/interface-endpoint-simple)
- [interface-endpoint-full](./examples/interface-endpoint-full)


## Self Promotion

Like this project? Follow the repository on [GitHub](https://github.com/tedilabs/terraform-aws-vpc-privatelink). And if you're feeling especially charitable, follow **[posquit0](https://github.com/posquit0)** on GitHub.


## License

Provided under the terms of the [Apache License](LICENSE).

Copyright © 2023-2026, [Byungjin Park](https://www.posquit0.com).