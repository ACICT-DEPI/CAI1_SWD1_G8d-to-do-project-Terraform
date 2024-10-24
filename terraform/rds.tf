# Create RDS Cluster
resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier      = var.rds_cluster_name
  engine                  = "mysql" # Use MySQL
  engine_version          = "8.0.35"  # Use a valid MySQL version
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = random_password.password.result
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  skip_final_snapshot = false

  final_snapshot_identifier = "${var.rds_cluster_name}-snapshot"

  tags = {
    Name = "${var.rds_cluster_name}"
  }
}

# Create RDS Instance
resource "aws_rds_cluster_instance" "rds_instance" {
  count                = 1
  identifier           = "${var.rds_cluster_name}-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.rds_cluster.id
  instance_class       = var.db_instance_class  # Use Free Tier eligible instance type
  engine               = var.db_engine
  engine_version       = "8.0.35"  # Use a valid MySQL version
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible  = true  # Set to true if you want to access it from outside the VPC
}