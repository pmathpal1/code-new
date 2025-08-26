pipeline {
    agent any

    parameters {
        string(name: 'LOCATION', defaultValue: 'eastus', description: 'Azure region')
    }

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'git@github.com:pmathpal1/code-new.git'
            }
        }

        stage('List Files for Debugging') {
            steps {
                script {
                    docker.image('alpine:latest').inside('--entrypoint=') {
                        sh 'ls -la'
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=') {
                        sh "terraform plan -var=\"location=${params.LOCATION}\""
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input 'Approve Terraform Apply?'
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=') {
                        sh "terraform apply -var=\"location=${params.LOCATION}\" -auto-approve"
                    }
                }
            }
        }
    }
}
