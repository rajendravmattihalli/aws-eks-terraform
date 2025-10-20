# Environment
variable "env" {
  type = string
}

# Type
variable "type" {
  type = string
}

# Stack name
variable "project_name" {
  type = string
}

# VPC CIDR
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]  
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.10.0/24","10.0.11.0/24","10.0.12.0/24"] 
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a","us-east-1b","us-east-1c"]
}
