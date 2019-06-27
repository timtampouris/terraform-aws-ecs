# ECS cluster
resource "aws_ecs_cluster" "ecs-test" {
  name = "ecs-test"
}

#Compute
resource "aws_autoscaling_group" "ecs-cluster" {
  name                      = "ecs-cluster"
  vpc_zone_identifier       = ["${aws_subnet.ecs-public-1.id}", "${aws_subnet.ecs-public-2.id}", "${aws_subnet.ecs-public-3.id}"]
  launch_configuration      = "${aws_launch_configuration.ecs-cluster-lc.name}"
  min_size                  = "2"
  max_size                  = "4"
  desired_capacity          = "2"
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "ecs-test"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "ecs-cluster" {
  name                      = "ecs-ecs-auto-scaling"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${aws_autoscaling_group.ecs-cluster.name}"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}

resource "aws_launch_configuration" "ecs-cluster-lc" {
  name_prefix     = "ecs-cluster-lc"
  security_groups = ["${aws_security_group.ecs-instance_sg.id}"]

  # key_name                    = "${aws_key_pair.ecs-test.key_name}"
  image_id                    = "${data.aws_ami.latest_ecs.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-ec2-role.id}"
  user_data                   = "${data.template_file.ecs-cluster.rendered}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
