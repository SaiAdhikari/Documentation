variable "cluster_name" {
  description = "Name of the ECS cluster"
  type    = string
}

variable "desired_count" {
  type    = number
  default = 1
  description = "Desired number of tasks to run in the ECS service"
}

variable "service_names" {
  type    = list(string)
  default = []
  description = "List of service names to update"
}
