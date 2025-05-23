
pipeline {
    agent any

tools {
    jdk 'Jdk17'
    maven 'Maven3'
}
 environment {
        DOCKER_IMAGE = "sandydocker19/spring-cicd:${BUILD_NUMBER}"
        
    }  
    
stages {

    stage('Cleanup Workspace') {
        steps {
            script {
                cleanWs()
            }
        }
    }
    
    stage("checkout"){
        steps{
            git branch: 'main', credentialsId: 'github-secret', url: 'https://github.com/sandy193/Spring-CICD.git'
        }
    }

    stage("build application"){
        steps{
            sh 'mvn clean package'
        }
    }

    stage("test application"){
        steps{
            sh 'mvn test'
        }
    }

    stage("sonarqube analysis"){
        steps {
            script {
                withSonarQubeEnv(credentialsId: 'sonar-secret'){
                    sh 'mvn sonar:sonar'
                }
            }
        }
    }

    stage('File system scan') {
    steps {
        sh "trivy fs --format table -o trivy-fs-reports.html ."
    }
    }

    stage('Build and Push Docker Image') {
      environment {
        REGISTRY_CREDENTIALS = credentials('docker-secret')
      }
      steps {
        script {
            sh 'docker context use default'  
            sh "docker build -t ${DOCKER_IMAGE} ."
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "docker-secret") {
                dockerImage.push()
            }
        }
      }
    }

    stage('Docker Image Scan') {
       steps {
                sh "trivy image --format table -o trivy-image-report.html ${DOCKER_IMAGE}"
            }
        }

    

    
  
    }   
}
