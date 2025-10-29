pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/aswinitinku/TrendStoreProject.git'
            }
        }
        stage('Build & Push Docker Image') {
			steps {
				script {
					def imageTag = "trend-app:${BUILD_ID}"
					withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
						sh '''
							docker build -t trend-app:${BUILD_ID} .
							docker tag trend-app:${BUILD_ID} aswinitinku/trend-app:${BUILD_ID}
							echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
							docker push aswinitinku/trend-app:${BUILD_ID}
						'''
					}
				}
			}
		}
		stage('Deploy to Kubernetes') {
			steps {
				withAWS(credentials: 'aws-eks-credentials', region: 'us-east-1') {
					withCredentials([file(credentialsId: 'eks-kubeconfig', variable: 'KUBECONFIG')]) {
						sh 'aws sts get-caller-identity'
						sh 'kubectl get nodes'
						sh 'kubectl apply -f deployment.yaml --validate=false'
						sh 'kubectl apply -f service.yaml --validate=false'
					}
				}
			}
		}
    }
}

