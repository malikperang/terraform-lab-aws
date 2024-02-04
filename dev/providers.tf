terraform {
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
  shared_config_files = [ "~/.aws/config" ]
  profile = "farizizwan" #IAM Roles
}