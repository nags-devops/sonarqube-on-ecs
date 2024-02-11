output "autoscaling_group" {
  value = aws_autoscaling_group.asg.id
}

output "kms_key_id" {
  value = aws_kms_key.volume_encryption_key.id
}