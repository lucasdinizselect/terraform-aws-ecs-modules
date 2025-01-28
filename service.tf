resource "aws_ecs_service" "main" {
  name                               = format("%s-service", var.service_name)
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  cluster                            = var.cluster_name
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  depends_on                         = [aws_ecs_task_definition.main, aws_iam_role.service_execution_role, aws_iam_role.task_role]

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = var.service_name
    container_port   = var.container_port
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.main.id]
    subnets          = var.subnets
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = var.listener_arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
  condition {
    host_header {
      values = [var.url]
    }
  }
  depends_on = [
    aws_lb_target_group.main
  ]
}

### Auto Scaling

resource "aws_appautoscaling_target" "main" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

### CPU POLICY

resource "aws_appautoscaling_policy" "main" {
  name               = format("%s-cpu-policy", var.service_name)
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.main.id
  scalable_dimension = aws_appautoscaling_target.main.scalable_dimension
  policy_type        = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    target_value = 70.0 # Uso de CPU alvo em porcentagem
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}