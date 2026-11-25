
resource "aws_autoscaling_policy" "drupal_cpu_scaling" {
  name                   = "drupal-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.drupal_app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value     = 50.0
    disable_scale_in = false
  }
}
