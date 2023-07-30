

# create security group to be used later by the ingress ALB
resource "aws_security_group" "alb" {
  name   = "nsg-${var.prefix_region_code}-${var.prefix_environment_code}-${var.prefix_environment_name}-eks-ingress-alb"
  vpc_id = var.vpc_id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "nsg-${var.prefix_region_code}-${var.prefix_environment_code}-${var.prefix_environment_name}-eks-ingress-alb"
  }
}
