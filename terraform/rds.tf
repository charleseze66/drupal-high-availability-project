
# Database subnet group
resource "aws_db_subnet_group" "drupal_db_subnets" {
  name = "drupal-db-subnet-group"

  subnet_ids = aws_subnet.private_db[*].id

  tags = {
    Name = "drupal-db-subnet-group"
  }
}

# Drupal MySQL database
resource "aws_db_instance" "drupal_db" {
  identifier = "drupal-ha-database"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.drupal_db_subnets.name
  vpc_security_group_ids = [aws_security_group.database.id]

  publicly_accessible = false
  multi_az            = true

  backup_retention_period = 1
  backup_window           = "02:00-03:00"

  auto_minor_version_upgrade = true
  deletion_protection        = false
  skip_final_snapshot        = true

  tags = {
    Name = "drupal-ha-database"
  }
}
