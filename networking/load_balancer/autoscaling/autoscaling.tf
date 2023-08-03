resource "aws_launch_template" "this" {
  name          = "template-tpl"
  image_id      = var.image_id
  instance_type = var.instance_type #"t2.micro"
  vpc_security_group_ids = var.vpc_security_group_ids
  #subnet_id = var.subnet_id
  key_name               = aws_key_pair.ssh_key.key_name

  tags = {
    Name = "web-server"
  }
  //user_data = file("${path.module}/script.sh")
  user_data = filebase64("${path.module}/script.sh")
  #instance_type = "${terraform.env == "prod" ? "t2.medium" : var.instance_type}"
  #key_name  = var.key_name != null ? var.key_name : null
  #user_data = filebase64("${path.module}/ec2-init.sh")


  # iam_instance_profile {
  #   name = "test"
  # }

  # vpc_security_group_ids = var.vpc_security_group_ids

  # Note: If using 'network_interfaces' like below then DON't user 'vpc_security_group_ids' separately. use 'security_groups' under network_interfaces
#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = var.vpc_security_group_ids
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags          = merge({ "ResourceName" = "${var.project}-tpl" }, local.tags)
#   }

  # depends_on = [
  #   aws_security_group.lb_sg
  # ]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  #public_key = file("${path.module}/ssh_key.pub")
  #public_key = var.key
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9k5lQzjdy3iPyfMo2lMMi0vxtWUnjuEb4OatuCJAvIqbX9GnArZhHbxSvetdnTiFSP78hwf3rIRbLQE2MkZr13oeHq1vUQzZHYht7ZjhESvsENEkf1QcKXlypl09OCWkLDRnjxmENiNXkYAOPu3GpMYd+vMRX30HKrjXzOcnrpsPn0Z/H5AJ/9Eo7pnkRkae+jydE/NY0BP3BFa2LiN+Mu5j+IMfbIjk7O77t7YSMvrK0JOLubuTEP3N57HOzQrVzZi/7PPP3CdChGzzcq3TSXgB4u8M++U5ce21GUc0IccfgSQymbP5WwloF2rgprstk8GGqfdz26iw6WS1QeU9H mayank@imp-itpl0175"
}

output "keyname" {
  value = aws_key_pair.ssh_key.key_name
}


resource "aws_autoscaling_group" "this" {

  name                      = "template-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB" #"ELB" or default EC2
  #availability_zones = var.availability_zones #["us-east-1a"]
  vpc_zone_identifier = var.psubnet_id
  target_group_arns   = var.target_group_arns #var.target_group_arns

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version #"$Latest"
  }

}
# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "template-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}


# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "template-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30" # New instance will be created once CPU utilization is higher than 30 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "template-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "template-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}