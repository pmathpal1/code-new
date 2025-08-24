pipeline {
    agent any

    environment {
        TF_VERSION = "1.13.0"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-ssh',
                    url: 'git@github.com:pmathpal1/code-new.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh """
                docker run --rm \
                    -v \$(pwd):/workspace \
                    -w /workspace \
                    hashicorp/terraform:${TF_VERSION} init
                """
            }
        }

        stage('Terraform Validate') {
            steps {
                sh """
                docker run --rm \
                    -v \$(pwd):/workspace \
                    -w /workspace \
                    hashicorp/terraform:${TF_VERSION} validate
                """
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID')
                ]) {
                    sh """
                    docker run --rm \
                        -v \$(pwd):/workspace \
                        -w /workspace \
                        -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
                        -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
                        -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
                        -e ARM_TENANT_ID=$ARM_TENANT_ID \
                        hashicorp/terraform:${TF_VERSION} plan -var-file=terraform.tfvars -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID')
                ]) {
                    sh """
                    docker run --rm \
                        -v \$(pwd):/workspace \
                        -w /workspace \
                        -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
                        -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
                        -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
                        -e ARM_TENANT_ID=$ARM_TENANT_ID \
                        hashicorp/terraform:${TF_VERSION} apply -auto-approve tfplan
                    """
                }
            }
        }
    }
}
