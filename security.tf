resource "aws_security_group" "lb_sg" {
  description = "controls access to the application ALB"

  vpc_id = "${aws_vpc.ecs-vpc.id}"
  name   = "ecs-ALB"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
     protocol    = "tcp"
     from_port   = 443
     to_port     = 443
     cidr_blocks = ["0.0.0.0/0"]
   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs-instance_sg" {
  description = "controls direct access to application instances"
  vpc_id      = "${aws_vpc.ecs-vpc.id}"
  name        = "ecs-app-instances-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 32768
    to_port     = 65535
    description = "Access from ALB"

    security_groups = [
      "${aws_security_group.lb_sg.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
