FROM jenkins/jenkins:lts-jdk17

USER root

# Docker CLI
RUN curl -fsSL https://get.docker.com | sh

# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
 && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
 && rm kubectl

# Python 3 + pip (E2E y Locust)
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# Jenkins necesita acceso al socket de Docker
RUN usermod -aG docker jenkins

USER jenkins
