# name default nacl
resource "aws_default_network_acl" "default-nacl" {
  default_network_acl_id  = aws_vpc.vpc.default_network_acl_id
  tags = {
    Name                  = "${var.env_id}-default-nacl"
  }
}

# create private nacl
resource "aws_network_acl" "private" {
  vpc_id                  = aws_vpc.vpc.id
  subnet_ids              = [ aws_subnet.sb-1-aza-private.id, aws_subnet.sb-2-azb-private.id ]
  tags = {
    Name                  = "${var.env_id}-private-nacl"
  }
}

resource "aws_network_acl_rule" "private-ingress" {
  network_acl_id          = aws_network_acl.private.id
  from_port               = -1
  to_port                 = -1
  protocol                = -1
  rule_number             = 100
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private-egress" {
  network_acl_id          = aws_network_acl.private.id
  from_port               = -1
  to_port                 = -1
  protocol                = -1
  rule_number             = 100
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
}

#create public nacl
resource "aws_network_acl" "public" {
  vpc_id                  = aws_vpc.vpc.id
  subnet_ids              = [ aws_subnet.sb-3-aza-public.id ]
  tags = {
    Name                  = "${var.env_id}-public-nacl"
  }
}

resource "aws_network_acl_rule" "public-ingress" {
  network_acl_id          = aws_network_acl.public.id
  from_port               = -1
  to_port                 = -1
  protocol                = -1
  rule_number             = 100
  rule_action             = "allow"
  cidr_block              = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public-egress" {
  network_acl_id         = aws_network_acl.public.id
  egress                 = true
  from_port              = -1
  to_port                = -1
  protocol               = -1
  rule_number            = 100
  rule_action            = "allow"
  cidr_block             = "0.0.0.0/0"
}