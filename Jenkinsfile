pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.13.0'   // full image with sh
            args '-v /var/jenkins_home/terraform:/terraform'
        }
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

        stage('Verify Credentials') {
            steps {
                sh '''
                    echo "✅ Azure credentials loaded successfully"
                    echo "Client ID: $ARM_CLIENT_ID"
                    echo "Tenant ID: $ARM_TENANT_ID"
                    echo "Subscription ID: $ARM_SUBSCRIPTION_ID"
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
                input message: 'Approve to apply changes?', ok: 'Deploy'
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
