pipeline {
    agent any

tools{
    jdk 'Jdk17'
    maven 'Maven3'
}   

environment {
    DOCKER_IMAGE = 'sandydocker19/SpringCICD:${BUILD_NUMBER}'
}

stages{
    stage('Cleanup Workspace') {
        steps {
            script {
                cleanWs()
            }
        }
    }
   stage('checkout') {
        steps {
            git branch: 'main',credentialsId: 'github-secret', url: 'https://github.com/sandy193/Spring-CICD.git'
        }
   }

   stage('sonarqube analysis') {
        steps {
            script {
                withSonarQubeEnv(credentialsId: 'sonar-secret')  {
                    sh 'mvn sonar:sonar'
                }
            }
        }
}

   stage('Build') {
        steps {
            script {
                sh 'mvn clean package -DskipTests'
            }
        }
}

   stage('Unit Test') {
        steps {
            script {
                sh 'mvn test'
            }
        }
}

   stage('File system scan') {
    steps {
        sh '/opt/homebrew/bin/trivy fs --format table -o trivy-fs-reports.html .'
    }
}

   stage('Build and Push Docker Image') {
        environment {
            REGISTRY_CREDENTIALS =  credentials('docker-secret')
        }
        steps {
            script {
                sh 'docker context use default'
                sh 'docker build -t ${DOCKER_IMAGE} .'
                def dockerImage = docker.image("${DOCKER_IMAGE}")
                docker.withRegistry('https://index.docker.io/v1/', 'docker-secret') {
                    dockerImage.push()
                }
            }
        }
    }

   stage('Docker Image Scan') {
     steps {
        sh '/opt/homebrew/bin/trivy image --format table -o trivy-image-reports.html ${DOCKER_IMAGE}'
    }
}
}
}
