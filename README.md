# Full-Stack Django Deployment Pipeline
This repository contains a production-grade deployment architecture for a Django-based full-stack application. It transitions the project from a local development environment to a highly available cloud environment using a GitOps approach.

## 🌟 Key Engineering Highlights 🌟
- **Infrastructure as Code (IaC)**: Used Terraform to provision immutable AWS infrastructure. This ensures that the production environment is version-controlled, repeatable, and free from "configuration drift."

- **Automated CI/CD (GitOps)**: Engineered a pipeline with GitHub Actions that triggers on every push. It handles containerization with Docker, runs automated test suites, and executes deployment, reducing lead time from hours to minutes.

- **Web Orchestration & Security**: Implemented Nginx as a reverse proxy. This setup optimizes performance through static file serving and enhances security by shielding the Django application server (Gunicorn/Uvicorn) from direct internet exposure.

## 🏗️ Architecture Overview
The system architecture is designed for scalability and consistency:

- **Frontend/Backend**: Django application logic served via Nginx.

- **Containerization**: Multi-stage Docker builds to keep image sizes small and secure.

- **CI/CD**: GitHub Actions builds the image, pushes to a container registry, and updates the infrastructure.

- **Cloud Provider**: AWS (Provisioned via Terraform).

## 📂 Repository Structure
```bash
├── .github/workflows/  # CI/CD Pipeline definitions
├── api/                # Django Backend source code
├── nginx/              # Nginx configuration (Reverse Proxy)
├── terraform/          # IaC scripts for AWS provisioning
├── docker-compose.yml  # Local orchestration for development
└── .env.example        # Template for environment variables
```
## 🛠️ Installation & Local Setup
To replicate the environment locally:

1. Clone the repo:

```bash

git clone https://github.com/KhushiKachhawaha14/Full-Stack-Django-Deployment-Pipeline.git
```
2. Configure Environment:

```bash

cp .env.example .env
# Edit .env with your local credentials
```
3. Launch with Docker:

```bash

docker-compose up --build
```
## 🚀 Deployment Pipeline
The pipeline follows these stages:

- **Linting/Testing**: Ensures code quality before any build.

- **Build**: Creates a production-ready Docker image.

- **Plan**: Terraform generates an execution plan for AWS.

- **Apply**: Terraform provisions/updates resources, and the new container is deployed.

## Contact
Khushi Kachhawaha | khushikachhawaha26@gmail.com
