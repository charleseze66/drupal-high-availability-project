
resource "aws_launch_template" "drupal_app" {
  name_prefix   = "drupal-app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.drupal_key.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.drupal_ssm_profile.name
  }

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 15
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "drupal-app"
      Role = "Drupal Application Server"
    }
  }
}

resource "aws_autoscaling_group" "drupal_app" {
  name                = "drupal-app-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = aws_subnet.private_app[*].id

  target_group_arns = [
    aws_lb_target_group.drupal_targets.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.drupal_app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "drupal-app"
    propagate_at_launch = true
  }
}
