pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/aswinitinku/TrendStoreProject.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("trend-app:${env.BUILD_ID}")
                }
            }
        }
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        docker.image("trend-app:${env.BUILD_ID}").push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }
}

