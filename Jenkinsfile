pipeline {
    agent any

    environment {
        //JAVA_HOME = '/path/to/java'      
        GRADLE_HOME = '/opt/gradle/latest'
        PATH = "${GRADLE_HOME}/bin:${env.PATH}"
        GITHUB_URL="https://github.com/Andriy29k/intern_project01.git"
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
                        script {
                            def scannerHome = tool name: 'SonarQube Scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    
                            withCredentials([string(credentialsId: 'SONARQUBE_TOKEN', variable: 'SONARQUBE_TOKEN')]) {
                                sh """
                                    ${scannerHome}/bin/sonar-scanner \\
                                    -Dsonar.projectKey=class_schedule \\
                                    -Dsonar.sources=src \\
                                    -Dsonar.java.binaries=build/classes/java/main \\
                                    -Dsonar.host.url=http://localhost:9000 \\
                            -Dsonar.login=$SONARQUBE_TOKEN
                        """
                    }
                }
            }
        }
    }
}


        stage('Build Frontend') {
            steps {
                dir('branch-dev') {
                    echo 'Building Frontend...' 
                    // sh 'npm install'
                    // sh 'npm run build'
                }
            }
        }
    }

}
