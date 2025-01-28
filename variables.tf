variable "service_name" {
  type        = string
  description = "Nome do serviço ECS"
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster ECS"
  default     = "DNS"
}

variable "url" {
  type        = string
  description = "URL associada ao serviço"
}

variable "fargate_cpu" {
  type        = number
  description = "Quantidade de CPU para o serviço"
  default     = 256
}

variable "fargate_memory" {
  type        = number
  description = "Quantidade de memória para o serviço"
  default     = 512
}

variable "desired_count" {
  type        = number
  description = "Número desejado de tarefas ECS"
  default     = 1
}

variable "min_capacity" {
  type        = number
  description = "Capacidade mínima do Auto Scaling"
  default     = 1
}

variable "max_capacity" {
  type        = number
  description = "Capacidade máxima do Auto Scaling"
  default     = 2
}

variable "container_port" {
  type        = number
  description = "Porta do contêiner"
  default     = 5000
}

variable "health_check" {
  type        = string
  description = "Endpoint de verificação de saúde"
  default     = "/api/healthcheck"
}

variable "host_port" {
  type        = number
  description = "Porta do host associada ao serviço"
  default     = 443
}

variable "security_group_port" {
  type        = number
  description = "Porta usada pelo Security Group"
  default     = 443
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "region" {
  type        = string
  description = "Região AWS"
}

variable "subnets" {
  type        = list(string)
  description = "Lista de subnets para o serviço ECS"
}

variable "lb_arn" {
  type        = string
  description = "ARN do Load Balancer"
}

variable "listener_arn" {
  type        = string
  description = "ARN do Listener do Load Balancer"
}

variable "scale_in_cooldown" {
  type = number
  default = 300
}

variable "scale_out_cooldown" {
  type = number
  default = 300
}