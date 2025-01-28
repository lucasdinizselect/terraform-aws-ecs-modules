resource "aws_ecs_task_definition" "main" {
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.service_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = format("%s:latest", aws_ecr_repository.main.repository_url)
      cpu       = var.fargate_cpu
      memory    = var.fargate_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.main.id
          awslogs-region        = var.region
          awslogs-stream-prefix = var.service_name
        }
      }
    }
  ])
}