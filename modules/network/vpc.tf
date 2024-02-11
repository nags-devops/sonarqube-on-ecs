# create VPC
resource "aws_vpc" "vpc" {
  enable_dns_hostnames   = true
  cidr_block             = var.vpc_cidr
  tags = {
    Name                 = "${var.env_id}-vpc",
    Environment          = var.env_id
  }
}

# create private subnets
resource "aws_subnet" "sb-1-aza-private" {
  vpc_id                 = aws_vpc.vpc.id
  cidr_block             = cidrsubnet(var.vpc_cidr,8,1)
  availability_zone      = "${var.region}a"

  tags = {
    Name                 = "${var.env_id}-sb-1-aza-private",
    Environment          = var.env_id,
    Zone                 = "Private"
  }
}

resource "aws_subnet" "sb-2-azb-private" {
  vpc_id                 = aws_vpc.vpc.id
  cidr_block             = cidrsubnet(var.vpc_cidr,8,2)
  availability_zone      = "${var.region}b"
  
  tags = {
    Name                 = "${var.env_id}-sb-2-azb-private",
    Environment          = var.env_id,
    Zone                 = "Private"
  }
}

# create public subnet(s)
resource "aws_subnet" "sb-3-aza-public" {
  vpc_id                 = aws_vpc.vpc.id
  cidr_block             = cidrsubnet(var.vpc_cidr,8,3)
  availability_zone      = "${var.region}a"
  tags = {
    Name                 = "${var.env_id}-sb-3-aza-public",
    Environment          = var.env_id,
    Zone                 = "Public"
  }
}