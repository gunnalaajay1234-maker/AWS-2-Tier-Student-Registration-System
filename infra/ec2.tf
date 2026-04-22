resource "aws_instance" "app_server" {
  ami                         = "ami-05d2d839d4f73aafb"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  key_name                    = "teja_mumbai"

  # user_data = file("script.sh")

  tags = {
    Name = "Flask-App-Server"
  }

  # REQUIRED FOR FILE COPY
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("teja_mumbai.pem")
    timeout     = "5m"
  }

  user_data = templatefile("script.sh", {
    db_host = aws_db_instance.mysql_db.address
    db_name = "employee_db"
    db_user = "admin"
    db_pass = "Password123!" # Ideally use a variable for this!
  })

}