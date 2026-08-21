###################################################
# Associations with Route53 Profiles
###################################################

resource "time_sleep" "wait" {
  create_duration = "10s"

  triggers = {
    endpoint_id  = aws_vpc_endpoint.this.id
    endpoint_arn = aws_vpc_endpoint.this.arn
  }
}

# INFO: Not supported attributes
# - `resource_properties`
resource "aws_route53profiles_resource_association" "this" {
  for_each = {
    for assoc in var.profile_associations :
    assoc.name => assoc
  }

  region = var.region

  resource_arn = time_sleep.wait.triggers["endpoint_arn"]

  name       = each.key
  profile_id = each.value.profile
}
