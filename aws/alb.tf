resource "aws_security_group" "gitea_security_group" {
  vpc_id      = aws_vpc.gitea_vpc.id
  description = "Allow SSH, HTTP and HTTPS traffic."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "gitea_alb" {
  name               = "gitea-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.gitea_security_group.id]
  subnets            = values(aws_subnet.gitea_subnet)[*].id
}

resource "aws_lb_target_group" "gitea_target_group" {
  name     = "gitea-target-group"
  port     = "3000"
  protocol = "HTTP"
  vpc_id   = aws_vpc.gitea_vpc.id
}

resource "aws_lb_target_group_attachment" "gitea_attachment" {
  target_group_arn = aws_lb_target_group.gitea_target_group.arn
  target_id        = aws_instance.gitea.id
  port             = 3000
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.gitea_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.gitea_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitea_target_group.arn
  }
}