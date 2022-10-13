# Security Group
# ALB security group
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.environment}-alb-sg"
  description = "alb security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-alb-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "alb_in_http" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_in_https" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_out_container" {
  security_group_id        = aws_security_group.alb_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.container_sg.id
}

# container Security Group
resource "aws_security_group" "container_sg" {
  name        = "${var.project}-${var.environment}-container-sg"
  description = "container security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-container-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "container_in_http" {
  security_group_id = aws_security_group.container_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  # source_security_group_id = aws_security_group.alb_sg.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "container_out_https" {
  security_group_id = aws_security_group.container_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  # source_security_group_id = aws_security_group.privatelink-sg.id
  cidr_blocks = ["0.0.0.0/0"]
}
# PrivateLink Security Group
resource "aws_security_group" "privatelink-sg" {
  name        = "${var.project}-${var.environment}-privatelink-sg"
  description = "container security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-privatelink-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "privatelink_in_https" {
  security_group_id        = aws_security_group.privatelink-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.container_sg.id
}
