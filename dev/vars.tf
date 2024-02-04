# vars.tf

variable "region" {
  description = "AWS region where EC2 instance will be provisioned"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami" {
  description = "ID of the Amazon Machine Image (AMI) to use for the EC2 instance"
  default     = "ami-12345678" # Replace with your desired AMI ID
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be deployed"
  # Set a default or specify when calling Terraform
}
