pipeline {
    agent {
        docker {
            image 'alpine:latest'
            args '-v ${env.WORKSPACE}:${env.WORKSPACE}'
        }
    }
    stages {
        stage('Test Docker') {
            steps {
                sh 'echo "Hello from inside the container!"'
                sh 'ls -la ${WORKSPACE}'
            }
        }
    }
}
