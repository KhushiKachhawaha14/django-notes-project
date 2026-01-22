terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Pull the Nginx image
resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}

# Create the Nginx container
resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.image_id
  name  = "notes_app_server"
  ports {
    internal = 80
    external = 8000
  }
}
