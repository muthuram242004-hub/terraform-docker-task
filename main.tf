# ---------------------------------------------------------------
# Task 3: Infrastructure as Code with Terraform
# Provisions a local Docker container using the Docker provider.
#
# Workflow:
#   terraform init      # download the Docker provider
#   terraform fmt       # (optional) format the code
#   terraform validate  # (optional) check syntax
#   terraform plan      # preview what will be created
#   terraform apply     # create the image + container
#   terraform state list / terraform state show <resource>
#   terraform destroy   # tear everything down
# ---------------------------------------------------------------

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Talks to the local Docker daemon.
# Linux/macOS: npipe:////./pipe/docker_engine
# Windows (Docker Desktop): npipe:////./pipe/docker_engine
provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

# ---------- Variables ----------
variable "image_name" {
  description = "Docker image to run"
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "tf-nginx"
}

variable "external_port" {
  description = "Host port mapped to the container's port 80"
  type        = number
  default     = 8000
}

# ---------- Resources ----------
# Pulls the image (or uses it if already present locally).
resource "docker_image" "web" {
  name         = var.image_name
  keep_locally = true # don't delete the image on destroy
}

# Runs a container from that image.
resource "docker_container" "web" {
  name  = var.container_name
  image = docker_image.web.image_id

  ports {
    internal = 80
    external = var.external_port
  }

  restart = "unless-stopped"

  labels {
    label = "managed-by"
    value = "terraform"
  }
}

# ---------- Outputs ----------
output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.web.id
}

output "container_name" {
  description = "Name of the Docker container"
  value       = docker_container.web.name
}

output "url" {
  description = "Open this in a browser"
  value       = "http://localhost:${var.external_port}"
}
