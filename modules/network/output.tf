output "vpc_id" {
  value = aws_vpc.vpc.id  
}

output "sb-1-aza-private" {
  value = aws_subnet.sb-1-aza-private.id
}

output "sb-2-azb-private" {
  value = aws_subnet.sb-2-azb-private.id
}

output "sb-3-aza-public" {
  value = aws_subnet.sb-3-aza-public.id
}

output "security-group" {
  value = aws_security_group.securtiy.id
}