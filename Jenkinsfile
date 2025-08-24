pipeline {
    agent any

    stages {
        stage('Terraform Init') {
            steps {
                sh """
                    docker run --rm \
                        -v ${WORKSPACE}:/workspace \
                        -w /workspace \
                        hashicorp/terraform:1.13.0 init
                """
            }
        }

        stage('Terraform Validate') {
            steps {
                sh """
                    docker run --rm \
                        -v ${WORKSPACE}:/workspace \
                        -w /workspace \
                        hashicorp/terraform:1.13.0 validate
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
                            -v ${WORKSPACE}:/workspace \
                            -w /workspace \
                            -e ARM_CLIENT_ID=${ARM_CLIENT_ID} \
                            -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} \
                            -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} \
                            -e ARM_TENANT_ID=${ARM_TENANT_ID} \
                            hashicorp/terraform:1.13.0 plan -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input "Do you want to apply the Terraform plan?"
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID')
                ]) {
                    sh """
                        docker run --rm \
                            -v ${WORKSPACE}:/workspace \
                            -w /workspace \
                            -e ARM_CLIENT_ID=${ARM_CLIENT_ID} \
                            -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} \
                            -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} \
                            -e ARM_TENANT_ID=${ARM_TENANT_ID} \
                            hashicorp/terraform:1.13.0 apply -auto-approve tfplan
                    """
                }
            }
        }
    }
}
