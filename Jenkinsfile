# =============================
# 1. Jenkinsfile
# =============================
pipeline {
    agent any

    environment {
        IMAGE_NAME = "poc-devops-essentials"
        IMAGE_TAG = "latest"
    }

    tools {
        maven 'Maven_3.9'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean verify'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Deploy with Helm to Minikube') {
            steps {
                sh 'helm upgrade --install poc-app helm/springboot-chart --namespace app --create-namespace -f helm/springboot-chart/values.yaml'
            }
        }

        stage('Terraform (OpenTofu) Validate') {
            steps {
                dir('tofu') {
                    sh 'tofu init'
                    sh 'tofu validate'
                    sh 'tofu plan -detailed-exitcode -out=tfplan'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Pipeline failure.'
        }
    }
}