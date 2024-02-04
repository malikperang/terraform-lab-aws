variable "region" {
    description = "Default Region"
    type        = string
    default     = "ap-southeast-1"
}

variable "environment" {
    description = "Default Environment"
    type        = string
    default     = "devops-showcase-jan2024"
}
variable "owner" {
    description = "Default Owner"
    type        = string
    default     = "devops-showcase-jan2024" //will be changed by tfvars
}
variable "tag_project" {
    description = "Project tag for the resources"
    type        = string
    default     = "devops-showcase-jan2024"
}