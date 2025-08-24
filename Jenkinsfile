pipeline {
    agent any

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

        stage('Terraform Init') {
            steps {
                sh '''
                    docker run --rm \
                      -v $PWD:/workspace \
                      -w /workspace \
                      -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
                      -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
                      -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
                      -e ARM_TENANT_ID=$ARM_TENANT_ID \
                      hashicorp/terraform:1.13.0 init
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                    docker run --rm \
                      -v $PWD:/workspace \
                      -w /workspace \
                      hashicorp/terraform:1.13.0 validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    docker run --rm \
                      -v $PWD:/workspace \
                      -w /workspace \
                      -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
                      -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
                      -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
                      -e ARM_TENANT_ID=$ARM_TENANT_ID \
                      hashicorp/terraform:1.13.0 plan -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                input 'Approve to apply changes?'
                sh '''
                    docker run --rm \
                      -v $PWD:/workspace \
                      -w /workspace \
                      -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
                      -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
                      -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
                      -e ARM_TENANT_ID=$ARM_TENANT_ID \
                      hashicorp/terraform:1.13.0 apply -auto-approve tfplan
                '''
            }
        }
    }
}
