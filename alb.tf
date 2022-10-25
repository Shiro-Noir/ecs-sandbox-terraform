resource "aws_lb" "alb" {
  name                       = "${var.project}-${var.environment}-alb"
  load_balancer_type         = "application"
  enable_deletion_protection = true
  idle_timeout               = 60
  internal                   = false

  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id,
  ]

  security_groups = [
    aws_security_group.alb_sg.id
  ]
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target.arn
  }
}

resource "aws_lb_target_group" "alb_target" {
  name                 = "${var.project}-${var.environment}-alb-target"
  target_type          = "ip"
  vpc_id               = aws_vpc.vpc.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
  depends_on = [
    aws_lb.alb
  ]
}