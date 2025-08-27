pipeline {
    agent any

    environment {
        ARM_TENANT_ID = credentials('arm-tenant-id')
        ARM_SUBSCRIPTION_ID = credentials('arm-subscription-id')
        ARM_CLIENT_ID = credentials('arm-client-id')
        ARM_CLIENT_SECRET = credentials('arm-client-secret')
    }

    parameters {
        string(name: 'LOCATION', defaultValue: 'eastus', description: 'Azure Region')
        string(name: 'RG_NAME', defaultValue: 'test-rg1', description: 'Resource Group Name')
        string(name: 'STORAGE_ACCOUNT_NAME', defaultValue: 'pankajmathpal99001122', description: 'Storage Account Name')
        string(name: 'CONTAINER_NAME', defaultValue: 'mycon1212', description: 'Container Name')
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy infrastructure?')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init (Local, Backend Disabled)') {
            steps {
                withDockerContainer('hashicorp/terraform:latest') {
                    sh 'terraform init -backend=false -input=false'
                }
            }
        }

        stage('Terraform Apply Backend Resources') {
            steps {
                withDockerContainer('hashicorp/terraform:latest') {
                    sh """
                        terraform apply \
                        -var="location=${params.LOCATION}" \
                        -var="rg_name=${params.RG_NAME}" \
                        -var="storage_account_name=${params.STORAGE_ACCOUNT_NAME}" \
                        -var="container_name=${params.CONTAINER_NAME}" \
                        -auto-approve -input=false
                    """
                }
            }
        }

        stage('Terraform Re-init with Remote Backend') {
            steps {
                withDockerContainer('hashicorp/terraform:latest') {
                    sh 'terraform init -reconfigure -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withDockerContainer('hashicorp/terraform:latest') {
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

        stage('Terraform Apply') {
            when {
                expression { return !params.DESTROY }
            }
            steps {
                withDockerContainer('hashicorp/terraform:latest') {
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

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY }
            }
            steps {
                withDockerContainer('hashicorp/terraform:latest') {
                    sh """
                        terraform destroy \
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
