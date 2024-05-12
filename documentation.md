# Project Name

## Overview
This project automates the provisioning and deployment of infrastructure and applications to Azure Kubernetes Service (AKS) using Terraform and GitHub Actions. It provides a streamlined workflow for managing cloud resources and deploying containerized applications on Kubernetes.

## Prerequisites
Before using this project, ensure you have the following:
- Azure account
- Azure Kubernetes Service (AKS) setup
- Azure Container Registry (ACR)
- GitHub account

## Repository Structure
- **k8s**: Contains Kubernetes deployment and service configurations.
- **Dockerfile**: Defines Docker commands for containerizing the application. It automatically triggers when a push is made to the main branch.

## GitHub Actions Workflows

### Terraform CI/CD
Automates the provisioning and updating of infrastructure using Terraform.

- **Trigger**: Pushes and pull requests to the `main` branch.
- **Jobs**:
  - **Terraform Deployment**: Initializes Terraform, plans, and applies Terraform configurations.

### Deploy to AKS
Handles continuous integration and deployment of the application to the AKS cluster.

- **Trigger**: Pushes and pull requests to the `main` branch.
- **Jobs**:
  - **Build and Deploy**: Builds the Docker image, pushes it to ACR, and deploys it to AKS using `kubectl`.

## Setup and Configuration

### Configuring Secrets
Configure the following GitHub Secrets to use the workflows:

- `ARM_CLIENT_ID`: Azure service principal client ID.
- `ARM_CLIENT_SECRET`: Azure service principal client secret.
- `ARM_SUBSCRIPTION_ID`: Azure subscription ID.
- `ARM_TENANT_ID`: Azure tenant ID.
- `ACR_USERNAME`: Azure Container Registry username.
- `ACR_PASSWORD`: Azure Container Registry password.
- `AZURE_CREDENTIALS`: Azure credentials in JSON format for AKS authentication.

### Workflow Usage
To use the workflows, simply push changes to your `main` branch or create a pull request. The workflows will handle Terraform operations and the deployment process automatically.
