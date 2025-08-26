pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
        LOCATION            = 'eastus'  // Your desired Azure region
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'git@github.com:pmathpal1/code-new.git'
            }
        }

        stage('List Files for Debugging') {
            agent {
                docker {
                    image 'alpine:latest'
                    args "-v ${env.WORKSPACE}:${env.WORKSPACE} -w ${env.WORKSPACE}"
                }
            }
            steps {
                sh 'ls -la'
            }
        }

        stage('Terraform Init') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args "-v ${env.WORKSPACE}:${env.WORKSPACE} -w ${env.WORKSPACE}"
                }
            }
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args "-v ${env.WORKSPACE}:${env.WORKSPACE} -w ${env.WORKSPACE}"
                }
            }
            steps {
                sh "terraform plan -var='location=${LOCATION}'"
            }
        }

        stage('Terraform Apply') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args "-v ${env.WORKSPACE}:${env.WORKSPACE} -w ${env.WORKSPACE}"
                }
            }
            steps {
                input 'Approve Terraform Apply?'
                sh "terraform apply -var='location=${LOCATION}' -auto-approve"
            }
        }
    }
}
