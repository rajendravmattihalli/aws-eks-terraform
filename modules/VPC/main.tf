# Creating VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
    Env  = var.env
    Type = var.type
  }
}

# Creating Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "eks_internet_gateway" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
    Env  = var.env
    Type = var.type
  }
}

# Public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "${var.project_name}-public-${count.index}" , "kubernetes.io/role/elb" = "1" , ENV = "${var.env}" ,Type = "${var.type}" }
}

# Route table for public subnets
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_internet_gateway.id
  }
  tags = { Name = "${var.project_name}-public-rt", ENV = "${var.env}" ,Type = "${var.type}"  }
}
resource "aws_route_table_association" "rta_public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt_public.id
}


# Private subnets (for worker nodes and workloads)
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  tags = { Name = "${var.project_name}-private-${count.index}" ,ENV = "${var.env}" ,Type = "${var.type}" , "kubernetes.io/role/internal-elb" = "1"}
}


# NAT gateways: one per AZ (costly, but production-grade HA)
resource "aws_eip" "nat" {
  count = length(aws_subnet.public)
  tags  = { Name = "${var.project_name}-nat-eip-${count.index}",ENV = "${var.env}" ,Type = "${var.type}"  }
}
resource "aws_nat_gateway" "natgw" {
  count         = length(aws_subnet.public)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags          = { Name = "${var.project_name}-nat-${count.index}",ENV = "${var.env}" ,Type = "${var.type}"  }
}

# Route tables for private subnets (attach NAT gateway by AZ)
resource "aws_route_table" "rt_private" {
  count  = length(aws_subnet.private)
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw[count.index].id
  }
  tags = { Name = "${var.project_name}-private-rt-${count.index}",ENV = "${var.env}" ,Type = "${var.type}"  }
}
resource "aws_route_table_association" "rta_private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rt_private[count.index].id
}

# Example NACL with conservative rules for public & private subnets
resource "aws_network_acl" "nacl_public" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = { Name = "${var.project_name}-public-nacl",ENV = "${var.env}" ,Type = "${var.type}"  }
}
resource "aws_network_acl" "nacl_private" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = { Name = "${var.project_name}-private-nacl",ENV = "${var.env}" ,Type = "${var.type}"  }
}

# Public NACL rules (allow HTTP/HTTPS/SSH ephemeral)
resource "aws_network_acl_rule" "public_inbound_http" {
  network_acl_id = aws_network_acl.nacl_public.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}
# (Add other rules as required: 443, ephemeral ports for return traffic, deny as last rule)
# Private NACL rules (allow ephemeral and necessary outbound)
resource "aws_network_acl_rule" "private_outbound_all" {
  network_acl_id = aws_network_acl.nacl_private.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Associate NACLs to subnets (public NACL -> public subnets, private NACL -> private)
resource "aws_network_acl_association" "nacl_public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  network_acl_id = aws_network_acl.nacl_public.id
}
resource "aws_network_acl_association" "nacl_private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  network_acl_id = aws_network_acl.nacl_private.id
}
