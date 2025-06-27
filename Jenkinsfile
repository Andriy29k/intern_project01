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
                        url: 'github-url',
                        credentialsId: 'github-credentials'
                }
            }
        }
    }
}
