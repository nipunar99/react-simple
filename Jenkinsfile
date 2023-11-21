pipeline {
    agent { docker { image 'node:20.9.0-alpine3.18' } }
    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}

pipeline {
    agent any

    tools {
        nodejs 'nodejs' // Assuming 'nodejs' is the Node.js tool name configured in Jenkins
    }

    environment {
        DOCKER_REGISTRY_CREDENTIALS = credentials('Dockercred')
        GIT_CREDENTIALS = credentials('gitcreds')
        SSH_KEY = credentials('sshkeypair')
    }

    stages {
        stage('Build') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[credentialsId: 'gitcreds', url: 'your_git_repo_url']]])
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm run test'
                echo "Test"
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t reactimage .'
            }
        }

        stage('Docker login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Dockercred', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                }
            }
        }

        stage('Push Image to Registry') {
            steps {
                sh 'docker tag reactimage:latest your_docker_registry_url/cloud001/dev:latest'
                sh 'docker push your_docker_registry_url/cloud001/dev:latest'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def dockerCmd = 'docker run -itd --name react_container -p 3000:3000 your_docker_registry_url/cloud001/dev:latest'
                    withCredentials([sshUserPrivateKey(credentialsId: 'sshkeypair', keyFileVariable: 'SSH_KEY_PATH')]) {
                        sh "ssh -o StrictHostKeyChecking=no -i $SSH_KEY_PATH ubuntu@34.238.155.217 ${dockerCmd}"
                    }
                }
            }
        }
    }
}