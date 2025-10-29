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
		stage('Push Docker Image') {
			steps {
				withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
					sh '''
						echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
						docker tag trend-app:${env.BUILD_ID} $DOCKER_USER/trend-app:${env.BUILD_ID}
						docker push $DOCKER_USER/trend-app:${env.BUILD_ID}
					'''
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

