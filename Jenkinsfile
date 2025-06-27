pipeline {
    agent any

    environment {
        GITHUB_URL = 'https://github.com/Andriy29k/intern_project01.git'
    }

    stages {
        stage('Checkout branches') {
            steps {
                git branch: 'main',
                    url: "${env.GITHUB_URL}",
                    credentialsId: 'github-credentials'

                dir('branch-dev') {
                    git branch: 'dev',
                        url: "${env.GITHUB_URL}",
                        credentialsId: 'github-credentials'
                }
            }
        }
        stage('Build Backend') {
            steps {
                tools {
                    gradle 'gradle-6.8'
                    java 'jdk11'
                }
                dir('backend/backend') {
                    sh 'gradle clean war'
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
