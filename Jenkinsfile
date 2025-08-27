pipeline {
    agent any

    environment {
        ARM_TENANT_ID        = credentials('AZURE_TENANT_ID')
        ARM_SUBSCRIPTION_ID  = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_CLIENT_ID        = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET    = credentials('AZURE_CLIENT_SECRET')
    }

    parameters {
        string(name: 'LOCATION', defaultValue: 'eastus', description: 'Azure region')
        string(name: 'RG_NAME', defaultValue: 'test-rg1', description: 'Resource Group name')
        string(name: 'STORAGE_ACCOUNT_NAME', defaultValue: 'pankajmathpal99001122', description: 'Storage Account name')
        string(name: 'CONTAINER_NAME', defaultValue: 'mycon1212', description: 'Storage Container name')
    }

    stages {
        stage('Terraform Init without backend') {
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh 'terraform init -backend=false'
                    }
                }
            }
        }

        stage('Terraform Apply Backend Infrastructure') {
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh """
                            terraform apply \
                              -var="location=${params.LOCATION}" \
                              -var="rg_name=${params.RG_NAME}" \
                              -var="storage_account_name=${params.STORAGE_ACCOUNT_NAME}" \
                              -var="container_name=${params.CONTAINER_NAME}" \
                              -auto-approve
                        """
                    }
                }
            }
        }

        stage('Terraform Re-init with Backend') {
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh """
                            terraform init \
                              -backend-config="resource_group_name=${params.RG_NAME}" \
                              -backend-config="storage_account_name=${params.STORAGE_ACCOUNT_NAME}" \
                              -backend-config="container_name=${params.CONTAINER_NAME}" \
                              -backend-config="key=terraform.tfstate" \
                              -reconfigure
                        """
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh """
                            terraform plan \
                              -var="location=${params.LOCATION}" \
                              -var="rg_name=${params.RG_NAME}" \
                              -var="storage_account_name=${params.STORAGE_ACCOUNT_NAME}" \
                              -var="container_name=${params.CONTAINER_NAME}"
                        """
                    }
                }
            }
        }

        stage('Terraform Apply Final Infra') {
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside('--entrypoint=""') {
                        sh """
                            terraform apply \
                              -var="location=${params.LOCATION}" \
                              -var="rg_name=${params.RG_NAME}" \
                              -var="storage_account_name=${params.STORAGE_ACCOUNT_NAME}" \
                              -var="container_name=${params.CONTAINER_NAME}" \
                              -auto-approve
                        """
                    }
                }
            }
        }
    }
}
