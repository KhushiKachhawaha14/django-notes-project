terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# 1. Create a Network so containers can talk to each other
resource "docker_network" "app_network" {
  name = "notes_network"
}

# 2. MySQL Database Container
resource "docker_image" "mysql_image" {
  name = "mysql:8.0"
}

resource "docker_container" "db" {
  name  = "mysql_db"
  image = docker_image.mysql_image.image_id
  networks_advanced { name = docker_network.app_network.name }
  env = [
    "MYSQL_ROOT_PASSWORD=password",
    "MYSQL_DATABASE=notes_db"
  ]
}

# 3. Django Backend Container
resource "docker_image" "django_app" {
  name = "django-notes-app:latest" # Ensure this matches your local build tag
}

resource "docker_container" "backend" {
  name  = "django_backend"
  image = docker_image.django_app.image_id
  networks_advanced { name = docker_network.app_network.name }
  ports {
    internal = 8000
    external = 8001
  }
  depends_on = [docker_container.db]
}
