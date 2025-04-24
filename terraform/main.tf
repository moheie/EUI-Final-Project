# Generate a private key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS key pair using the generated public key
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key-pair"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/ec2-key-pair.pem"
  file_permission = "0600"  # Secure permissions for the private key
}

# Create a security group that allows specific inbound traffic
resource "aws_security_group" "allow_web" {
  name        = "allow-web-traffic"
  description = "Allow HTTP and Jenkins inbound traffic for EC2 instances"

  ingress {
    description = "HTTP for Webserver"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-web-traffic"
  }
}

# Create Jenkins EC2 instance
resource "aws_instance" "jenkins" {
  ami           = var.ec2-ubuntu-ami
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name = aws_key_pair.ec2_key.key_name
  user_data = file("${path.module}/ec2-userdata/jenkins-userdata.sh")
  #user_data_replace_on_change = true
  tags = {
    Name = "jenkins-ec2"
  }
}

# Create Webserver EC2 instance
resource "aws_instance" "webserver" {
  ami           = var.ec2-ubuntu-ami
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name = aws_key_pair.ec2_key.key_name

  tags = {
    Name = "webserver-ec2"
  }
}

# Create Elastic IP for Jenkins and associate it
resource "aws_eip" "jenkins_eip" {
  instance = aws_instance.jenkins.id
  domain   = "vpc"

  tags = {
    Name = "jenkins-ec2-eip"
  }
}

# Create Elastic IP for Webserver and associate it
resource "aws_eip" "webserver_eip" {
  instance = aws_instance.webserver.id
  domain   = "vpc"

  tags = {
    Name = "webserver-ec2-eip"
  }
} 