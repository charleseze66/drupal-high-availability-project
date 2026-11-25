
resource "aws_lb" "drupal_alb" {
  name               = "drupal-ha-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  tags = {
    Name = "drupal-ha-alb"
  }
}

resource "aws_lb_target_group" "drupal_targets" {
  name     = "drupal-ha-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.drupal_vpc.id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "drupal-ha-targets"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.drupal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.drupal_targets.arn
  }
}
