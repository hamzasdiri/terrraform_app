pipeline {
    agent {
        label 'jenkins-agent'
    }
    tools {
        nodejs 'node'
    }
    environment {
        APP_NAME = "myShopApp"
        RELEASE = "1.0.0"
        DOCKER_USER = "13646891"
        DOCKER_PASS = "dockerhub"
        IMAGE_NAME = "myShopApp - ${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/hamzasdiri/terrraform_app']]
                ])
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm install'
            }
        }
        
        stage('Test') {
            steps {
                echo "No tests"
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                    docker_image = docker.build("${IMAGE_NAME}", "-f DockerFile .")
                    }
                    docker.withRegistry('',DOCKER_PASS) {
                    docker_image.push("${IMAGE_TAG}")
                    docker_image.push("latest")
                    }
                }
            }
        }

        stage('Terraform Init and Apply') {
            steps {
                script {
                    sh 'terraform init -upgrade'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Retrieve VM Information') {
            steps {
                script {
                    vmIP = sh(script: 'terraform output vm_ip', returnStdout: true).trim()
                    vmUsername = sh(script: 'terraform output vm_username', returnStdout: true).trim()
                }
            }
        }

        stage('Deploy Docker Image to VM') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_PASS) {
                        dockerImage = docker.build("${IMAGE_NAME}", "-f DockerFile .")
                    }
                    sshagent(['your-ssh-credentials-id']) {
                        sh "ssh ${vmUsername}@${vmIP} 'docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}'"
                        sh "docker save -o image.tar ${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "scp -i /path/to/your/private/key image.tar ${vmUsername}@${vmIP}:/path/on/vm"
                        sh "ssh ${vmUsername}@${vmIP} 'docker load -i /path/on/vm/image.tar'"
                        sh "ssh ${vmUsername}@${vmIP} 'docker run -d -p 80:80 ${IMAGE_NAME}:${IMAGE_TAG}'"
                    }
                }
            }
        }


    }
}
