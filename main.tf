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

  # Professional Health Check
  healthcheck {
    test     = ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-ppassword"]
    interval = "5s"
    timeout  = "5s"
    retries  = 5
  }
}

# 3. Django Backend Container
resource "docker_container" "backend" {
  name  = "django_backend"
  image = docker_image.django_app.image_id
  networks_advanced { name = docker_network.app_network.name }
  
  # Ensure the DB is fully ready before starting Django
  depends_on = [docker_container.db]

  ports {
    internal = 8000
    external = 8001
  }
}

# 4. Nginx Reverse Proxy Container
resource "docker_image" "nginx_image" {
  name = "nginx:latest"
}

resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.image_id
  name  = "notes_app_server"
  
  # Connects the proxy to your Django app and DB
  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 80
    external = 8000
  }
  
  # Crucial: This ensures Nginx starts only AFTER the Django backend is up
  depends_on = [docker_container.backend]

  # Mounts your custom config to override the "Welcome to Nginx" page
  volumes {
    host_path      = "${path.cwd}/nginx.conf"
    container_path = "/etc/nginx/conf.d/default.conf" # Internal path for Nginx config
  }

  # Mounts static files (CSS/JS/Images)
  volumes {
    host_path      = "${path.cwd}/static"
    container_path = "/usr/share/nginx/html/static"
  }
}
