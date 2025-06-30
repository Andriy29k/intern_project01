pipeline {
    agent any

    environment {
        //JAVA_HOME = '/path/to/java'      
        // GRADLE_HOME = '/opt/gradle/latest'
        // PATH = "${GRADLE_HOME}/bin:${env.PATH}"
        GITHUB_URL="https://github.com/Andriy29k/intern_project01.git"
    }

    tools {
        gradle 'gradle-6.8'
        jdk 'jdk-11'
        // sonar 'SonarQube'
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

        stage('Frontend Tests') {
            steps {
                dir('frontend') {
                    dir('frontend') {
                        sh 'node -v'
                        sh 'npm test --watchAll=false'
                    }
                }
            }
        }

        stage('Infrastructure Tests') {
            steps {
                dir('infrastructure') {
                    dir('infrastructure') {
                        sh 'terraform init'
                        sh 'terraform validate'
                        sh 'terraform plan'
                    }
                }
            }
        }

        // stage('Infrastructure Deployment') {
        //     steps {
        //         dir('infrastructure') {
        //             dir('infrastructure') {
        //                 sh 'terraform apply -auto-approve'
        //             }
        //         }
        //     }
        // }

        // stage('Backend Docker build') {
        //     steps {
        //         dir('backend') {
        //             sh 'docker build -t class_schedule_backend .'
        //             sh 'docker save class_schedule_backend | gzip > backend-docker-image.tar.gz'
        //             archiveArtifacts artifacts: 'backend-docker-image.tar.gz', fingerprint: true
        //         }
        //     }
        // }

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
