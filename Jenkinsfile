pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
        //DOCKER_IMAGE= "anithapatcha/springboot:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: "main", credentialsId: 'git-cred-ID', url: 'https://github.com/ChavaSirisha/MarketingProject1.git'
            }
        }
        stage('Maven Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Maven Test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BoardGame -Dsonar.projectKey=BoardGame \
                                                       -Dsonar.java.binaries=. -Dsonar.exclusions=**/trivy-fs-report.html'''
                }
            }
        }
        // stage('Quality Gate') {
        //     steps {
        //         script {
        //             waitForQualityGate abortPipeline: false, credentialsId: 'sonar'
        //         }
        //     }
        // }
        // stage('Maven Build') {
        //     steps {
        //         sh 'mvn package -DskipTests'
        //     }
        // }
        // stage('Maven Deploy') {
        //     steps {
        //         sh 'mvn deploy -DskipTests' 
        //     }
        // }
        // stage('Build Docker Image and Tag') {
        //     steps {
        //         script {
        //             withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
        //             sh 'docker build -t ${DOCKER_IMAGE} .'
        //             }
        //         }
        //     }
        // }  
        // stage('Docker Image Scan') {
        //     steps {
        //         sh 'trivy image --format table -o try-image-report.html ${DOCKER_IMAGE}'
        //     }
        // } 
        // stage('Push Docker Image') {
        //     steps {
        //         script {
        //             withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
        //                 sh 'docker push ${DOCKER_IMAGE}'
        //             }
        //         }
        //     } 
        // }
        // stage ('Deploy to Kubernetes'){
        //     steps {
        //         script {
        //             sh 'kubectl apply -f deployment-services.yaml'
        //             sh 'kubectl apply -f svc.yaml'
        //         }
        //     }
        // }  
    }
}