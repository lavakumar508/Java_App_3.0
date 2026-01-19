@Library('my-shared-library') _

pipeline {
    agent any

    parameters {
        choice(name: 'action', choices: 'create\ndelete', description: 'Choose create/Destroy')
        string(name: 'ImageName', defaultValue: 'javapp', description: 'Docker image name')
        string(name: 'ImageTag', defaultValue: 'v1', description: 'Docker image tag')
        string(name: 'DockerHubUser', defaultValue: 'praveensingam1994', description: 'DockerHub username')
    }

    stages {

        stage('Git Checkout') {
            when { expression { params.action == 'create' } }
            steps {
                gitCheckout(
                    branch: "main",
                    url: "https://github.com/praveen1994dec/Java_app_3.0.git"
                )
            }
        }

        stage('Unit Test - Maven') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    mvnTest()
                }
            }
        }

        stage('Integration Test - Maven') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    mvnIntegrationTest()
                }
            }
        }

        stage('Static Code Analysis - SonarQube') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    def sonarCred = 'sonarqube-api'
                    statiCodeAnalysis(sonarCred)
                }
            }
        }

        stage('Quality Gate Check - SonarQube') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    def sonarCred = 'sonarqube-api'
                    QualityGateStatus(sonarCred)
                }
            }
        }

        stage('Upload Artifact to JFrog') {
            when { expression { params.action == 'create' } }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'jfrog-creds',
                    usernameVariable: 'JF_USER',
                    passwordVariable: 'JF_PASS'
                )]) {
                    sh '''
                    curl -u $JF_USER:$JF_PASS \
                    -T target/kubernetes-configmap-reload-0.0.1-SNAPSHOT.jar \
                    http://18.144.83.52:8082/artifactory/example-repo-local/kubernetes-configmap-reload-0.0.1-SNAPSHOT.jar
                    '''
                }
            }
        }

        stage('Maven Build') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    mvnBuild()
                }
            }
        }

        stage('Docker Build') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    dockerBuild(params.ImageName, params.ImageTag, params.DockerHubUser)
                }
            }
        }

        stage('Docker Image Scan - Trivy') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    dockerImageScan(params.ImageName, params.ImageTag, params.DockerHubUser)
                }
            }
        }

        stage('Docker Push') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    dockerImagePush(params.ImageName, params.ImageTag, params.DockerHubUser)
                }
            }
        }

        stage('Docker Cleanup') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    dockerImageCleanup(params.ImageName, params.ImageTag, params.DockerHubUser)
                }
            }
        }
    }
}

