pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'
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

        stage('Debug Environment') {
            steps {
                sh '''
                    echo "🔍 Debugging container environment..."
                    echo "PATH: $PATH"
                    which terraform || echo "terraform not found in PATH"
                    terraform version || echo "terraform command failed"
                    
                    echo "📂 Current working directory:"
                    pwd

                    echo "📂 Listing files:"
                    ls -la
                '''
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
                sh '''
                    echo "Running Terraform Init..."
                    if terraform init; then
                        echo "Terraform init succeeded ✅"
                    else
                        echo "⚠️ terraform init failed, trying fallback..."
                        terraform terraform init || (echo "❌ Both init attempts failed" && exit 1)
                    fi
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    echo "Running Terraform Plan..."
                    if terraform plan -out=tfplan; then
                        echo "Terraform plan succeeded ✅"
                    else
                        echo "❌ Terraform plan failed"
                        exit 1
                    fi
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                input 'Approve to apply changes?'
                sh '''
                    echo "Running Terraform Apply..."
                    if terraform apply -auto-approve tfplan; then
                        echo "Terraform apply succeeded ✅"
                    else
                        echo "❌ Terraform apply failed"
                        exit 1
                    fi
                '''
            }
        }
    }
}
