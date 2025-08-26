pipeline {
    agent any
    stages {
        stage('Test Docker') {
            agent {
                docker {
                    image 'alpine:latest'
                    args "-v ${env.WORKSPACE}:${env.WORKSPACE} -w ${env.WORKSPACE}"
                }
            }
            steps {
                sh 'echo "Inside alpine container"'
                sh 'ls -la'
                sh 'sleep 10'  // keep container alive briefly for debugging
            }
        }
    }
}
