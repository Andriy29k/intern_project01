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
        nodejs 'nodejs-24'
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
        // stage('Build Backend') {
        //     steps {
        //         dir('backend') {
        //             dir('backend'){
        //                 sh 'gradle clean build -x test'
        //                 sh 'ls -l build/libs'
        //             }
        //         }
        //     }
        // }

        // stage('Backend Tests') {
        //     steps {
        //         dir('backend') {
        //             dir('backend') {
        //                 sh 'gradle test'
        //             }
        //         }
        //     }
        // }

        // stage('Sonar Scanning') {
        //     steps {
        //         withSonarQubeEnv('SonarQube') {
        //             sh 'sonar-scanner -Dproject.settings=sonar-project.properties'
        //         }
        //     }
        // }

        // stage('Build Frontend') {
        //     steps {
        //         dir('frontend') {
        //             dir('frontend') {
        //                 sh 'npm install'
        //                 sh 'npm run build'
        //                 sh 'tar -czf frontend-artifact.tar.gz build/' 
        //                 archiveArtifacts artifacts: 'frontend-artifact.tar.gz', fingerprint: true
        //             }
        //         }
        //     }
        // }

        // stage('Upload Artifacts to GCS') {
        //     steps {
        //         script {
        //             def gcloud = tool 'google-cloud-sdk'
        //             withEnv(["PATH=${gcloud}/bin:${env.PATH}"]) {
        //                 withCredentials([
        //                     file(credentialsId: 'GCP_CREDS_JSON', variable: 'GOOGLE_APPLICATION_CREDENTIALS'),
        //                     file(credentialsId: 'RESTORE_DUMP', variable: 'DB_DUMP_PATH')]) {
        //                     dir('frontend/frontend') {
        //                         sh '''
        //                             gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
        //                             gsutil cp frontend-artifact.tar.gz gs://class-schedule-artifacts/frontend-artifacts/
        //                         '''
        //                     }
        //                     dir('backend/backend/build/libs') {
        //                         sh '''
        //                             gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
        //                             gsutil cp class_schedule.war gs://class-schedule-artifacts/backend-artifacts/ROOT.war
        //                         '''
        //                     }
        //                     sh """
        //                         gcloud auth activate-service-account --key-file="\$GOOGLE_APPLICATION_CREDENTIALS"
        //                         gsutil cp "\$DB_DUMP_PATH" gs://class-schedule-artifacts/database-artifacts/
        //                     """
        //                 }
        //             }
        //         }
        //     }
        // }


        stage('Deploy Infrastructure') {
            steps {
                dir('terraform') {
                    withCredentials([file(credentialsId: 'TERRAFORM-TFVARS', variable: 'TFVARS_FILE')]) {
                        withCredentials([file(credentialsId: 'GCP_CREDS_JSON', variable: 'GOOGLE_CREDENTIALS')]) {
                            sh """    
                                terraform init
                                terraform validate
                                terraform plan -var 'google_credentials_file=$GOOGLE_CREDENTIALS' -var-file="$TFVARS_FILE"
                                terraform apply -auto-approve -var 'google_credentials_file=$GOOGLE_CREDENTIALS' -var-file="$TFVARS_FILE"
                            """
                        }
                    }
                }
            }   
        }
        
        stage {
            dir('ansible') {
                dir('files') {
                    sh 'bash generate_inventory.sh'
                }
            }
        }

        stage('Destroy Infrastructure') {
            steps {
                input message: 'Are you sure you want to destroy infrastructure?'
                dir('terraform') {
                    withCredentials([file(credentialsId: 'TERRAFORM-TFVARS', variable: 'TFVARS_FILE')]) {
                        withCredentials([file(credentialsId: 'GCP_CREDS_JSON', variable: 'GOOGLE_CREDENTIALS')]) {
                            sh """
                               terraform destroy -auto-approve -var "google_credentials_file=${GOOGLE_CREDENTIALS}" -var-file="${TFVARS_FILE}"
                            """
                        }
                    }
                }
            }   
        } 

        // stage('Terraform Lint') {
        //     steps {
        //         dir('terraform') {
        //             sh '''
        //                 curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash -s -- -b $HOME/.local/bin
        //                 export PATH=$HOME/.local/bin:$PATH
        //                 tflint --init
        //                 tflint
        //            '''
        //         }
        //     }
        // }

        // stage('Docker images build') {
        //     steps {
        //         withCredentials([usernamePassword(
        //                 credentialsId: 'DOCKERHUB_CREDENTIALS', 
        //                 usernameVariable: 'DOCKERHUB_USERNAME', 
        //                 passwordVariable: 'DOCKERHUB_PASSWORD'
        //         )]) {
        //             sh 'echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin'
        //             sh "docker build -t $DOCKERHUB_USERNAME/$BACKEND_IMAGE_NAME:$IMAGE_TAG ./backend"
        //             sh "docker build -t $DOCKERHUB_USERNAME/$FRONTEND_IMAGE_NAME:$IMAGE_TAG ./frontend"
        //             sh "docker push $DOCKERHUB_USERNAME/$BACKEND_IMAGE_NAME:$IMAGE_TAG"
        //             sh "docker push $DOCKERHUB_USERNAME/$FRONTEND_IMAGE_NAME:$IMAGE_TAG"
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
