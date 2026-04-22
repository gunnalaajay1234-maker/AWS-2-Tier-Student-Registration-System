resource "aws_db_subnet_group" "subgrp" {
  name = "my_rds_subnet_group"
  subnet_ids = [ aws_subnet.subnet2.id, aws_subnet.subnet3.id ]
  tags = {
    name = "My rds subnet group"
  }
}