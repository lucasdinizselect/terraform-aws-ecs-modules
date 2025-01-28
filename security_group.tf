resource "aws_security_group" "main" {
  name        = format("%s-sg", var.service_name)
  description = "Allow Port 443"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.security_group_port
    to_port     = var.security_group_port
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