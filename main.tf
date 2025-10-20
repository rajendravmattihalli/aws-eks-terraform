# Creating VPC
module "vpc" {
  source       = "./modules/VPC"
  project_name = var.project_name
  env          = var.env
  type         = var.type
}

# Creating security group
module "security_groups" {
  source       = "./modules/Security_groups"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  ssh_access   = var.ssh_access
  http_access  = var.http_access
  env          = var.env
  type         = var.type
}

# Creating key pair
module "key_pair" {
  source   = "./modules/Key-Pair"
  key_name = var.key_name
}

# Creating IAM resources
module "iam" {
  source = "./modules/IAM"
  project_name = var.project_name
}

# Creating EKS Cluster
module "eks" {
  source                = "./modules/EKS"
  master_arn            = module.iam.master_arn
  worker_arn            = module.iam.worker_arn
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  env                   = var.env
  type                  = var.type
  key_name              = var.key_name
  eks_security_group_id = module.security_groups.eks_security_group_id
  instance_size         = var.instance_size
  project_name          = var.project_name
}