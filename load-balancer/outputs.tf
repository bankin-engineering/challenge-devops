output "target_group_arn" {
  value = "${aws_alb_target_group.ecs-target_group.arn}"
}