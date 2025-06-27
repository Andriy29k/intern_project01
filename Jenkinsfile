pipeline {
    agent any

    environment {
        JAVA_HOME = tool name: 'jdk11', type: 'hudson.model.JDK'
        GRADLE_HOME = tool name: 'gradle-6.8', type: 'hudson.plugins.gradle.GradleInstallation'
        PATH = "${GRADLE_HOME}/bin:${JAVA_HOME}/bin:${env.PATH}"
        GITHUB_URL = 'https://github.com/Andriy29k/intern_project01.git'
    }

    tools {
        gradle 'gradle-6.8'
        jdk 'jdk11'
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
                dir('backend/backend') {
                    sh './gradlew clean war'
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
