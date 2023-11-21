// pipeline {
//     agent { docker { image 'node:20.9.0-alpine3.18' } }
//     stages {
//         stage('Build') {
//             steps {
//                 echo 'Building..'
//             }
//         }
//         stage('Test') {
//             steps {
//                 echo 'Testing..'
//             }
//         }
//         stage('Deploy') {
//             steps {
//                 echo 'Deploying....'
//             }
//         }
//     }
// }
pipeline {
    agent { docker { image 'node:20.9.0-alpine3.18' } }

    environment {
        DOCKER_REGISTRY_CREDENTIALS = credentials('Dockercred')
        GIT_CREDENTIALS = credentials('gitcreds')
        // SSH_KEY = credentials('sshkeypair')
    }

    stages {
        stage('Build') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[credentialsId: 'gitcreds', url: 'https://github.com/nipunar99/react-simple.git']]])
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                // sh 'npm run test'
                echo "Test"
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t react-simple .'
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
                sh 'docker tag react-simple:latest rnip052899/react-simple:latest'
                sh 'docker push rnip052899/react-simple:latest'
            }
        }

        // stage('Deploy') {
        //     steps {
        //         script {
        //             def dockerCmd = 'docker run -itd --name react_container -p 3000:3000 rnip052899/react-simple:latest'
        //             withCredentials([sshUserPrivateKey(credentialsId: 'sshkeypair', keyFileVariable: 'SSH_KEY_PATH')]) {
        //                 sh "ssh -o StrictHostKeyChecking=no -i $SSH_KEY_PATH user@172.20.58.16 ${dockerCmd}"
        //             }
        //         }
        //     }
        // }
    }
}
