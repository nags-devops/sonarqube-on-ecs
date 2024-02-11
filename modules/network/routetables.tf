# name default route table
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id  = aws_vpc.vpc.default_route_table_id
  tags = {
    Name                  = "${var.env_id}-default-rt"
  }
}

# create private route table
resource "aws_route_table" "private-rt" {
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name                  = "${var.env_id}-private-rt",
    Environment           = var.env_id,
    Zone                  = "Private"
  }
}

resource "aws_route_table_association" "private-1" {
  subnet_id               = aws_subnet.sb-1-aza-private.id
  route_table_id          = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id               = aws_subnet.sb-1-aza-private.id
  route_table_id          = aws_route_table.private-rt.id
}

#create public route table
resource "aws_route_table" "public-rt" {
  vpc_id                  = aws_vpc.vpc.id
  tags = {
    Name                  = "${var.env_id}-public-rt"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id                  = aws_vpc.vpc.id
  tags = {
    Name                  = "${var.env_id}-igw"
  }
}

resource "aws_route" "public-igw" {
  route_table_id          = aws_route_table.public-rt.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "private-001" {
  subnet_id               = aws_subnet.sb-3-aza-public.id
  route_table_id          = aws_route_table.public-rt.id
}