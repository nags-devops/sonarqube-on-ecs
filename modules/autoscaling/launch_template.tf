data "template_file" "user-data" {
  template = file("${path.module}/user_data.tftpl")

  vars = {
    cluster_name = var.env_id
  }
}

resource "aws_launch_template" "ecs_instance_lt" {
  name                   = "${var.env_id}-launch-template"
  image_id               = "ami-0884cb613f1c64662"
  instance_type          = "t3.medium"
  key_name               = var.ec2-keypair
  user_data              = base64encode(data.template_file.user-data.rendered)
  vpc_security_group_ids = [ var.security_group ]
  update_default_version = true

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
      encrypted = true
      kms_key_id = aws_kms_key.volume_encryption_key.arn
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.env_id}-worker-node"
    }
  }
}