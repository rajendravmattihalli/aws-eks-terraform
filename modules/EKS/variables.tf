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

variable "private_subnet_ids" {
  type    = list(string)
}

variable "public_subnet_ids" {
  type    = list(string)
}

# Security Group 
variable "eks_security_group_id" {
  type = string
}

# Master ARN
variable "master_arn" {
  type = string
}

# Worker ARN
variable "worker_arn" {
  type = string
}

# Key name
variable "key_name" {
  type = string
}

# Worker Node & Kubectl instance size
variable "instance_size" {
  type = string
}