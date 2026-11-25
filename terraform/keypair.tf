
resource "aws_key_pair" "drupal_key" {
  key_name = "drupal-ha-key"

  public_key = file(
    pathexpand("~/.ssh/drupal-ha-key.pub")
  )

  tags = {
    Name = "drupal-ha-key"
  }
}
