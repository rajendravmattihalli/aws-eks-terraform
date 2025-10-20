# VPC ID
output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

# Internet Gateway ID
output "internet_gateway" {
  value = aws_internet_gateway.eks_internet_gateway.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.natgw[*].id
}

output "nat_eip_ids" {
  description = "List of Elastic IPs allocated for NAT Gateways"
  value       = aws_eip.nat[*].id
}

output "public_route_table_id" {
  description = "Route table ID for public subnets"
  value       = aws_route_table.rt_public.id
}

output "private_route_table_ids" {
  description = "List of route table IDs for private subnets"
  value       = aws_route_table.rt_private[*].id
}

output "public_nacl_id" {
  description = "Network ACL ID for public subnets"
  value       = aws_network_acl.nacl_public.id
}

output "private_nacl_id" {
  description = "Network ACL ID for private subnets"
  value       = aws_network_acl.nacl_private.id
}

output "public_nacl_assoc_ids" {
  description = "Associations of public NACL to subnets"
  value       = aws_network_acl_association.nacl_public_assoc[*].id
}

output "private_nacl_assoc_ids" {
  description = "Associations of private NACL to subnets"
  value       = aws_network_acl_association.nacl_private_assoc[*].id
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = var.azs
}