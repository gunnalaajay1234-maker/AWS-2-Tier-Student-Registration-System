provider "aws" {
  region = "ap-south-1"
# Load .env into your PowerShell session
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
  region = "ap-south-1"
  tags = {
    Name = "Myappvpc"
  }
  
}
resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Public Subnet"
  }
  
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Private Subnet1"
  }
  
}

resource "aws_subnet" "subnet3" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "ap-south-1c"
  tags = {
    Name = "Private Subnet2"
  }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "app_vpc_igw"
  }
  
}

resource "aws_route_table" "publicroute" {
  vpc_id =  aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.publicroute.id
}

resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.vpc.id
  name = "Ec2 app sg"
  description = "Security group for EC2 application server"
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TCp"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "App_sg"
  }
  
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.vpc.id
  name = "RDS-DB-SG"
  description = "Security group for RDS MySQL database"
  ingress {
    description = "Mysql/Aurora"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  tags = {
    Name = "RDS_sg"
  }
}



