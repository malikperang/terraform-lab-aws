# locals.tf

locals {
  # Mapping of AWS regions to abbreviated codes
  region_map = {
    "us-east-1"      = "usea1"
    "us-west-2"      = "uswe2"
    "eu-west-1"      = "euwe1"
    "ap-southeast-1" = "apse1"
    "ap-southeast-2" = "apse2"
    # Add more regions as needed
  }

  # Local variable to retrieve the abbreviated region code
  region = local.region_map[var.region]

  # Prefix for resource names based on region and environment
  resource_prefix = "${local.region}.${var.environment}"

  # Common tags for resources
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
    # Add more common tags as needed
  }
}
