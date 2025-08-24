pipeline {
    agent any

    environment {
        TF_IMAGE = 'hashicorp/terraform:1.13.0'
        TF_WORKDIR = "${WORKSPACE}/infra"   // your Terraform folder in repo
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID')
                ]) {
                    sh """
                        docker run --rm \
                          -v ${WORKSPACE}:${WORKSPACE} \
                          -w ${TF_WORKDIR} \
                          -e ARM_CLIENT_ID=${ARM_CLIENT_ID} \
                          -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} \
                          -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} \
                          -e ARM_TENANT_ID=${ARM_TENANT_ID} \
                          ${TF_IMAGE} init
                    """
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh """
                    docker run --rm \
                      -v ${WORKSPACE}:${WORKSPACE} \
                      -w ${TF_WORKDIR} \
                      ${TF_IMAGE} validate
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
                          -v ${WORKSPACE}:${WORKSPACE} \
                          -w ${TF_WORKDIR} \
                          -e ARM_CLIENT_ID=${ARM_CLIENT_ID} \
                          -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} \
                          -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} \
                          -e ARM_TENANT_ID=${ARM_TENANT_ID} \
                          ${TF_IMAGE} plan -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Apply Terraform changes?", ok: "Apply"
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID', variable: 'ARM_TENANT_ID')
                ]) {
                    sh """
                        docker run --rm \
                          -v ${WORKSPACE}:${WORKSPACE} \
                          -w ${TF_WORKDIR} \
                          -e ARM_CLIENT_ID=${ARM_CLIENT_ID} \
                          -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} \
                          -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} \
                          -e ARM_TENANT_ID=${ARM_TENANT_ID} \
                          ${TF_IMAGE} apply -auto-approve tfplan
                    """
                }
            }
        }

    }
}