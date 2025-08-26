pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
        LOCATION            = 'eastus'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'git@github.com:pmathpal1/code-new.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${env.WORKSPACE}") {
                    script {
                        docker.image('hashicorp/terraform:latest').inside {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${env.WORKSPACE}") {
                    script {
                        docker.image('hashicorp/terraform:latest').inside {
                            sh "terraform plan -var='location=${LOCATION}'"
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Approve Terraform Apply?'
                dir("${env.WORKSPACE}") {
                    script {
                        docker.image('hashicorp/terraform:latest').inside {
                            sh "terraform apply -var='location=${LOCATION}' -auto-approve"
                        }
                    }
                }
            }
        }
    }
}
