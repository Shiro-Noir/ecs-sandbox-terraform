# ECS Cluster

resource "aws_ecs_cluster" "ecs-sandbox-cluster" {
  name = "${var.project}-${var.environment}-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "ecs-sandbox-cluster-capacity_providers" {
  cluster_name       = aws_ecs_cluster.ecs-sandbox-cluster.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "ecs-sandbox-taskdefinition" {
  execution_role_arn       = "arn:aws:iam::653076675421:role/ecsTaskExecutionRole"
  family                   = "${var.project}-${var.environment}-definition"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./task-definition.json")
  volume {
    name = "mount-point"
  }
}

resource "aws_ecs_service" "ecs-sandbox-service" {
  launch_type     = "FARGATE"
  name            = "${var.project}-${var.environment}-service"
  cluster         = aws_ecs_cluster.ecs-sandbox-cluster.id
  task_definition = aws_ecs_task_definition.ecs-sandbox-taskdefinition.arn
  desired_count   = 1

  network_configuration {
    assign_public_ip = true
    subnets = [
      aws_subnet.public_subnet_1a.id
    ]

    security_groups = [
      aws_security_group.container_sg.id
    ]
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

}


resource "aws_cloudwatch_log_group" "ecs-sandbox-definiton-log-group" {
  name = "/ecs/ecs-sandbox-definiton"
}