pipeline {
    agent any

    environment {
        TF_IMAGE = "hashicorp/terraform:1.13.0"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh """
                    docker run --rm \
                    -v ${WORKSPACE}:/workspace \
                    -w /workspace \
                    ${TF_IMAGE} init
                """
            }
        }

        stage('Terraform Validate') {
            steps {
                sh """
                    docker run --rm \
                    -v ${WORKSPACE}:/workspace \
                    -w /workspace \
                    ${TF_IMAGE} validate
                """
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'azure-service-principal',
                        usernameVariable: 'ARM_CLIENT_ID',
                        passwordVariable: 'ARM_CLIENT_SECRET'
                    ),
                    string(credentialsId: 'azure-subscription-id', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'azure-tenant-id', variable: 'ARM_TENANT_ID')
                ]) {
                    sh """
                        docker run --rm \
                        -v ${WORKSPACE}:/workspace \
                        -w /workspace \
                        -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
                        -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
                        -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
                        -e ARM_TENANT_ID=$ARM_TENANT_ID \
                        ${TF_IMAGE} plan -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'azure-service-principal',
                        usernameVariable: 'ARM_CLIENT_ID',
                        passwordVariable: 'ARM_CLIENT_SECRET'
                    ),
                    string(credentialsId: 'azure-subscription-id', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'azure-tenant-id', variable: 'ARM_TENANT_ID')
                ]) {
                    sh """
                        docker run --rm \
                        -v ${WORKSPACE}:/workspace \
                        -w /workspace \
                        -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
                        -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
                        -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
                        -e ARM_TENANT_ID=$ARM_TENANT_ID \
                        ${TF_IMAGE} apply -auto-approve tfplan
                    """
                }
            }
        }
    }
}
