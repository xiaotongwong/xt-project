data "aws_ami" "amazon_linux" {
   most_recent = true
   owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Amazon Linux2 AMI
  }
}

resource "aws_instance" "gitea" {
  ami           = data.aws_ami.amazon_linux
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              docker run -d --name gitea -p 3000:3000 -p 22:22 docker.gitea.com/gitea:nightly
              EOF

  tags = {
    Name = "gitea_vm"
  }
}
