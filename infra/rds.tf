resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"

  subnet_ids = [
    aws_subnet.subnet2.id,
    aws_subnet.subnet3.id
  ]

  tags = {
    Name = "RDS Subnet Group"
  }
}



resource "aws_db_instance" "mysql_db" {
  identifier             = "myapp-db"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "employee_db"
  username               = "admin"
  password               = "Password123!"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "MySQL-RDS"
  }
}
