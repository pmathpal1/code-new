pipeline {
    agent any
    stages {
        stage('Test Terraform Docker') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args "-v ${env.WORKSPACE}:${env.WORKSPACE} -w ${env.WORKSPACE}"
                }
            }
            steps {
                sh 'terraform version'
                sh 'ls -la'
                sh 'sleep 10'  // keep container alive briefly for debugging
            }
        }
    }
}
