#######################################
# APPLICATION LOAD BALANCER
#######################################
resource "aws_lb" "app_alb" {
  name               = "mini-project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "MiniProject-ALB"
  }
}

#######################################
# TARGET GROUP
#######################################
resource "aws_lb_target_group" "app_tg" {
  name        = "mini-project-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }

  tags = {
    Name = "MiniProject-TG"
  }
}

#######################################
# ALB LISTENER (HTTP)
#######################################
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

#######################################
# REGISTER EC2 INSTANCE WITH TG
#######################################
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = var.ec2_instance_id
  port             = 80
}
