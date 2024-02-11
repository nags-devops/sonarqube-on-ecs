data "aws_caller_identity" "current" {}

data "aws_key_pair" "ec2-keypair" {
  key_name           = "${var.env_id}-ec2-keypair"
}
