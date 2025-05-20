pipeline {
    agent any

    environment {
        IMAGE_NAME = "poc-devops-essentials"
        TAG = "latest"
        REGISTRY = "localhost:5000"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://seu-repositorio.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh 'docker build -t $REGISTRY/$IMAGE_NAME:$TAG .'
                sh 'docker push $REGISTRY/$IMAGE_NAME:$TAG'
            }
        }

        stage('OpenTofu Infra Provision') {
            steps {
                dir('tofu') {
                    sh 'tofu init'
                    sh 'tofu apply -auto-approve'
                }
            }
        }

        stage('Deploy com Helm') {
            steps {
                dir('helm/springboot-chart') {
                    sh """
                        helm upgrade --install $IMAGE_NAME . \
                        --set image.repository=$REGISTRY/$IMAGE_NAME \
                        --set image.tag=$TAG
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finalizado'
        }
        success {
            echo 'Deploy realizado com sucesso!'
        }
        failure {
            echo 'Falha no pipeline.'
        }
    }
}
