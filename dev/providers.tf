terraform {
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
  # shared_config_files = var.TFE_WORKSPACE_NAME != "" ? [] : ["~/.aws/config"]
  profile = "farizizwan" #IAM Roles
}