resource "aws_db_subnet_group" "aws_db_subnet_group" {
  name       = "main"
  subnet_ids = data.aws_subnet_ids.available_db_subnet.ids
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage    = 10
  engine               = var.engine_name
  instance_class       = var.instance_class
  name                 = var.db_name
  username             = var.user_name
  password             = var.pass
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_sub_group.id
  delete_automated_backups = var.delete_automated_backups
  multi_az = var.multi_az_deployment
  publicly_accessible = var.public_access
  vpc_security_group_ids = [data.aws_security_groups.tcw_sg.id]

}

resource "aws_db_instance_role_association" "db_role" {
  db_instance_identifier = aws_db_instance.db_instance.id
  feature_name           = "S3_INTEGRATION"
  role_arn               = "arn:aws:iam::667481606687:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"
}