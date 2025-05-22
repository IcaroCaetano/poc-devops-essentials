# 🌐 poc-devops-essentials

### A fully containerized DevOps-ready Java 21 application with CI/CD, infrastructure as code, monitoring, and Kubernetes deployments using:

- Java 21 + Spring Boot 3 (Maven)
- Jenkins (CI/CD pipeline)
- Docker (image creation and local testing)
- Helm (Kubernetes application deployment)
- Minikube (local Kubernetes cluster)
- OpenTofu (Infrastructure as Code)
- Prometheus + Grafana (Observability & Monitoring)
- Kubernetes Namespaces (for isolation of infra and apps)
- Spring Actuator (`/actuator`, `/actuator/prometheus`)

---

## 📌 Project Features

- Exposes a single endpoint: `GET /hello` → `"Hello, Java 21!"`
- Export Prometheus metrics through Spring Boot Actuator
- Deployable to Kubernetes using Helm
- Infrastructure provisioned using OpenTofu
- Fully integrated with Jenkins pipelines (CI/CD)

---

## 🧰 Requirements

### 🖥️ Install on **Windows 11** or **macOS**

| Tool             | Windows Installation                                | macOS Installation                        |
|------------------|-----------------------------------------------------|-------------------------------------------|
| **Java 21**      | [Download](https://jdk.java.net/21/) and set `JAVA_HOME` | Use `brew install openjdk@21`             |
| **Maven**        | [Download](https://maven.apache.org/)               | `brew install maven`                      |
| **Docker Desktop** | [Download for Windows](https://www.docker.com/products/docker-desktop/) | `brew install --cask docker`              |
| **Minikube**     | `choco install minikube`                            | `brew install minikube`                   |
| **Kubectl**      | `choco install kubernetes-cli`                      | `brew install kubectl`                    |
| **Helm**         | `choco install kubernetes-helm`                     | `brew install helm`                       |
| **OpenTofu**     | `scoop install opentofu` or [manual](https://opentofu.org) | `brew install opentofu`                   |
| **Jenkins**      | Run via Docker (see below)                          | Run via Docker (see below)                |

---

## 🚀 Running Locally

### 1. Start Minikube

```yaml

minikube start --driver=docker
```

### Set Docker to use Minikube's internal Docker daemon:

````yaml

minikube -p minikube docker-env --shell powershell | Invoke-Expression  # Windows PowerShell
# OR
eval $(minikube -p minikube docker-env)  # macOS/Linux
````

### 2. Build Docker Image

````yaml
docker build -t poc-devops-essentials:latest .
````

### 3. Create Namespaces

````yaml
kubectl create namespace infrastructure
kubectl create namespace application
````

### 4. Deploy Monitoring (Prometheus + Grafana)

````yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack \ --namespace infrastructure --create-namespace
````

### 🔍 After deployment:

Grafana: http://localhost:<PORT> (use minikube service to expose)

Prometheus: http://localhost:<PORT>

### 5. Deploy Application via Helm

````yaml

helm install poc-devops-app ./helm/springboot-chart --namespace application
````
Expose the service:

````yaml
minikube service poc-devops-app --namespace application
````

Test endpoint:

````yaml

curl http://<EXPOSED-IP>:<PORT>/hello
````

### 6. Run Jenkins in Docker

````bash

docker run -d -p 8081:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v //var/run/docker.sock:/var/run/docker.sock \
  -v "%cd%":/var/jenkins_home/workspace \
  --name jenkins-devops jenkins/jenkins:lts

````
Access Jenkins at: http://localhost:8081

### 7. Jenkins Pipeline (Jenkinsfile)
The pipeline performs the following:

- Installs dependencies

- Runs unit tests

- Builds Docker image

- Deploys to Minikube via Helm

````groovy

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t poc-devops-essentials:latest .'
            }
        }
        stage('Helm Deploy') {
            steps {
                sh 'helm upgrade --install poc-devops-app ./helm/springboot-chart --namespace application'
            }
        }
    }
}

````

## 📦 Project Structure

````css

project-root/
├── src/
│   └── main/java/com/.../HelloController.java
├── tofu/
│   ├── main.tf
│   ├── variables.tf
│   └── providers.tf
├── helm/
│   └── springboot-chart/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   └── service.yaml
│       └── Chart.yaml
├── Jenkinsfile
├── Dockerfile
└── README.md

````

## 📊 Observability (Grafana & Prometheus)

The application is configured to expose metrics at:

- /actuator/prometheus

- /actuator/health

- /actuator/info

Grafana dashboards can be configured to scrape Prometheus which pulls from the application's /actuator/prometheus.

## 📄 OpenTofu (Infrastructure as Code)

Initialize and apply your infrastructure:

````bash

cd tofu
tofu init
tofu plan
tofu apply

````
You can write OpenTofu tests using the terratest framework or tools like infracost or opa.

## 🔐 Security Notes

- Secure Jenkins with an admin password

- Rotate Docker/Helm tokens if used

- Consider using Kubernetes secrets for production

## ✅ Final Checklist
 
- One /hello endpoint

- CI/CD working with Jenkins

- Monitoring via Prometheus/Grafana

- Helm deployments into two namespaces

- Local cluster with Minikube

- Docker image built and deployed

- Infrastructure managed with OpenTofu

