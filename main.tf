# Initialize the ECS client
provider "aws" {
  region = "us-east-1"
}

# Define the ECS cluster
data "aws_ecs_cluster" "cluster" {
  cluster_name = var.cluster_name
}

# Get the list of services in the cluster
data "aws_ecs_service" "services" {
  for_each = toset(var.service_names)
  cluster_arn = data.aws_ecs_cluster.cluster.arn
  service_name = each.key
}


locals {
  service_list = [ for service in var.service_names :
                   service if contains(split("\n", file("services.txt")), service)
                 ]
}

# Update the service to stop new tasks from starting
resource "null_resource" "update_service" {
  for_each = toset(var.service_names)

  provisioner "local-exec" {
    command = "aws ecs update-service --cluster ${data.aws_ecs_cluster.cluster.arn} --service ${each.value} --desired-count ${var.desired_count}"
  }
}

