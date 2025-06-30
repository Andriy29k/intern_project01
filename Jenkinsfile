pipeline {
    agent any

    environment {
        GITHUB_URL="https://github.com/Andriy29k/intern_project01.git"
        BACKEND_IMAGE_NAME = 'class_schedule_backend'
        FRONTEND_IMAGE_NAME = 'class_schedule_frontend'
        IMAGE_TAG = 'latest'
    }

    tools {
        gradle 'gradle-6.8'
        jdk 'jdk-11'
        nodejs 'nodejs-18'
        terraform 'terraform-50623'
    }

    stages {
        stage('Checkout branch') {
            steps {
                git branch: 'dev',
                    url: "${env.GITHUB_URL}",
                    credentialsId: 'github-credentials'
            }
        }
        stage('Build Backend') {
            steps {
                dir('backend') {
                    dir('backend'){
                        sh 'gradle clean -x test'
                    }
                }
            }
        }

        stage('Backend Tests') {
            steps {
                dir('backend') {
                    dir('backend') {
                        sh 'gradle test'
                    }
                }
            }
        }

       stage('Sonar Scanning') {
            steps {
                dir('backend') {
                    dir('backend') {
                       withSonarQubeEnv(installationName: 'SonarQube') {
                            sh '''
                            sonar-scanner \
                                -Dsonar.projectKey=class_schedule \
                                -Dsonar.sources=src \
                                -Dsonar.java.binaries=build/classes/java/main
                            '''
                        }
                    }
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    dir('frontend') {
                        sh 'npm install'
                        sh 'npm run build'
                        sh 'tar -czf frontend-artifact.tar.gz build/' 
                        archiveArtifacts artifacts: 'frontend-artifact.tar.gz', fingerprint: true
                    }
                }
            }
        }

        stage('Terraform Lint') {
            steps {
                sh '''
                    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
                    tflint --init
                    tflint
                '''
            }
        }


        // stage('Infrastructure Tests') {
        //     steps {
        //         dir('terraform') {
        //             sh 'terraform init'
        //             sh 'terraform validate'
        //             sh 'terraform plan'
        //         }
        //     }
        // }
        

        // stage('Infrastructure Deployment') {
        //     steps {
        //         dir('infrastructure') {
        //             dir('infrastructure') {
        //                 sh 'terraform apply -auto-approve'
        //             }
        //         }
        //     }
        // }

        stage('Docker images build') {
            steps {
                withCredentials([usernamePassword(
                        credentialsId: 'DOCKERHUB_CREDENTIALS', 
                        usernameVariable: 'DOCKERHUB_USERNAME', 
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                )]) {
                    sh 'echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin'
                    sh "docker build -t $DOCKERHUB_USERNAME/$BACKEND_IMAGE_NAME:$IMAGE_TAG ./backend"
                    sh "docker build -t $DOCKERHUB_USERNAME/$FRONTEND_IMAGE_NAME:$IMAGE_TAG ./frontend"
                    sh "docker push $DOCKERHUB_USERNAME/$BACKEND_IMAGE_NAME:$IMAGE_TAG"
                    sh "docker push $DOCKERHUB_USERNAME/$FRONTEND_IMAGE_NAME:$IMAGE_TAG"
                }
            }
        }

        // stage('Frontend Docker build') {
        //     steps {
        //         dir('frontend') {
        //             sh 'docker build -t class_schedule_backend .'
        //             sh 'docker save class_schedule_backend | gzip > backend-docker-image.tar.gz'
        //             archiveArtifacts artifacts: 'backend-docker-image.tar.gz', fingerprint: true
        //         }
        //     }
        // }
    }
}
