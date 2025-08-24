pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'
            args '-v /var/jenkins_home/terraform:/terraform'
            reuseNode true
        }
    }

    options {
        shell('/bin/sh')   // explicitly tell Jenkins to use /bin/sh
    }

    environment {
        ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
        AZURE_LOCATION      = "East US"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:pmathpal1/code-new.git'
            }
        }

        stage('Debug Environment') {
            steps {
                sh '''
                    echo "🔍 Debugging container environment..."
                    which terraform || echo "terraform not found"
                    terraform version || echo "terraform failed"
                    pwd
                    ls -la
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input 'Approve to apply changes?'
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
