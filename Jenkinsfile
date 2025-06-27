pipeline {
    agent any

    environment {
        //JAVA_HOME = '/path/to/java'      
        GRADLE_HOME = '/opt/gradle/latest'
        PATH = "${GRADLE_HOME}/bin:${env.PATH}"
    }

    tools {
        //gradle 'gradle-6.8'
        jdk 'jdk11'
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

        stage('Test Backend') {
            steps {
                dir('backend') {
                    dir('backend') {
                        sh 'gradle test'
                    }
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('branch-dev') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }
    }

}
