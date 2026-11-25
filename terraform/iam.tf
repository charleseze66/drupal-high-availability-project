
resource "aws_iam_role" "drupal_ssm_role" {
  name = "drupal-ha-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "drupal-ha-ssm-role"
  }
}

resource "aws_iam_role_policy_attachment" "drupal_ssm_policy" {
  role = aws_iam_role.drupal_ssm_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "drupal_ssm_profile" {
  name = "drupal-ha-ssm-profile"
  role = aws_iam_role.drupal_ssm_role.name
}
