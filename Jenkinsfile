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
        nodejs 'nodejs-14'
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
    }
}
