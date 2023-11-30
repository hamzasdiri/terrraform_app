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
        imgname = "13646891/my-image"
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

        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build imgname
                }
            }
        }

        stage('Deploy Image to Dockerhub') {
            steps{
                script {
                    docker.withRegistry( '',  'dockerhub') {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                    }
                }
        }

        stage('Deploy to Azure App Service') {
            steps {
                script {
                    // Set Azure credentials
                    
                        // Initialize Terraform
                        bat 'terraform init'
                        
                        // Apply Terraform configuration, passing the Docker image URL as a variable
                        bat "terraform apply -auto-approve -var 'docker_image_url=13646891/my-image'"
                    
                }
            }
        }


    }
}
