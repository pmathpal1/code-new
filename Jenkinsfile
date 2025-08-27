pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
    }

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy infrastructure')
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Debug Params') {
            steps {
                echo "DESTROY parameter is: ${params.DESTROY}"
            }
        }

        stage('Terraform Init (Local)') {
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh 'terraform init -backend=false'
                    }
                }
            }
        }

        stage('Terraform Apply to Create Backend') {
            when {
                expression { !params.DESTROY }
            }
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh 'terraform apply -auto-approve -target=azurerm_storage_account.sa -target=azurerm_storage_container.container'
                    }
                }
            }
        }

        stage('Terraform Re-init with Remote Backend') {
            when {
                expression { !params.DESTROY }
            }
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { !params.DESTROY }
            }
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply (Final Infra)') {
            when {
                expression { !params.DESTROY }
            }
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }

        stage('Confirm Destroy') {
            when {
                expression { params.DESTROY }
            }
            steps {
                input message: 'Do you want to destroy the infrastructure?', ok: 'Destroy'
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.DESTROY }
            }
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}
