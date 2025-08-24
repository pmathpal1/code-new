pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.13.0'
            args '--entrypoint=/bin/sh -v /var/jenkins_home/terraform:/terraform'
        }
    }

    environment {
        AZURE_LOCATION = "East US"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:pmathpal1/code-new.git'
            }
        }

        stage('Terraform Pipeline') {
            steps {
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID')
                ]) {
                    sh '''
                        echo "✅ Azure credentials loaded successfully"
                        echo "Client ID: $ARM_CLIENT_ID"
                        echo "Tenant ID: $ARM_TENANT_ID"
                        echo "Subscription ID: $ARM_SUBSCRIPTION_ID"

                        echo "=== Terraform Init ==="
                        terraform init

                        echo "=== Terraform Plan ==="
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input 'Approve to apply changes?'
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID')
                ]) {
                    sh '''
                        echo "=== Terraform Apply ==="
                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }
    }
}
