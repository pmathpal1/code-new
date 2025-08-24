pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.13.0'
            args '--entrypoint=/bin/sh'
        }
    }
    stages {
        stage('Test Container') {
            steps {
                sh 'terraform version'
            }
        }
    }
}
