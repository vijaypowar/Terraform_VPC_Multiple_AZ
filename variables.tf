# Variables for setting up terraform

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "my_credentials" {
  description = "Credentials to be used to connect to AWS"
  type        = list(string)
}

variable "my_profile" {
  description = "Profile to be used to connect to AWS"
  type        = string
}

## Variables for creating the VPC and Subnets

variable "avail_zone" {
  description = "Availability zone"
  type        = list(string)
}
variable "cidr_block" {
  description = "VPC IP range"
  type        = string
}

# Variables for EC2 instance

variable "instance_type" {
  type = string
}

variable "my_ip" {
  type = string
}

variable "ami_id" {
  description = "instance_type"
  type        = string
  default     = ""
}

variable "ebs_size" {
  description = "ebs_size"
  type        = string
  default     = "8"
}

