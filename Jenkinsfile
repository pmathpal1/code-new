pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'
            args '-v /var/jenkins_home/terraform:/terraform'
        }
    }

    environment {
        AZURE_LOCATION = "East US"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:pmathpal1/terraform-azure-infra.git'
            }
        }

        stage('Set Azure Credentials') {
            steps {
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID')
                ]) {
                    sh '''
                        echo "Azure credentials loaded in environment."
                        echo "Client ID: $ARM_CLIENT_ID"
                        echo "Tenant ID: $ARM_TENANT_ID"
                        echo "Subscription ID: $ARM_SUBSCRIPTION_ID"
                    '''
                }
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