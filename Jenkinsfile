pipeline {
    agent any

    environment {
        DOCKER_IMAGE = '10.252.10.21:5000/company-profile'
        DOCKER_TAG = 'latest'
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        K8S_NAMESPACE = 'default'
        DISCORD_WEBHOOK = 'https://discord.com/api/webhooks/1385272768718966884/rbdcP8PJsFR77FZWxCCvWwgBTl9BmPyQSIZK8BUB3D-qIXwzW5rYvovR3Ghpn1zmi06z'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('http://10.252.10.21:5000', "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Apply Deployment to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f k8s/deployment.yaml --namespace ${K8S_NAMESPACE}"
                }
            }
        }

        stage('Apply Service to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f k8s/service.yaml --namespace ${K8S_NAMESPACE}"
                }
            }
        }

        stage('Apply Ingress to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f k8s/ingress.yaml --namespace ${K8S_NAMESPACE}"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh "kubectl get pods --namespace ${K8S_NAMESPACE}"
                }
            }
        }
    }

    post {
        always {
            discordSend description: "Name: ${env.JOB_NAME}\nBuild: ${env.BUILD_NUMBER} \nStatus: ${currentBuild.currentResult} \nBranch: main", customUsername: "Jenkins Notification" , enableArtifactsList: true, footer: "Mirza Maulana Azmi", link: env.BUILD_URL , showChangeset: true, result: currentBuild.currentResult, title: "Build Status of " + env.JOB_NAME, webhookURL: "${DISCORD_WEBHOOK}"
        }
    }
}
