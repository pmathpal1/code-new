pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'
            args '-v /var/jenkins_home/terraform:/terraform'
        }
    }

    environment {
        AZURE_LOCATION = "East US"
    }

    stages {
        stage('Set Azure Credentials') {
            steps {
                withCredentials([string(credentialsId: 'jenkins-terraform-spp', variable: 'AZURE_CREDENTIALS')]) {
                    script {
                        def json = readJSON text: env.AZURE_CREDENTIALS
                        env.ARM_CLIENT_ID       = json.clientId
                        env.ARM_CLIENT_SECRET   = json.clientSecret
                        env.ARM_SUBSCRIPTION_ID = json.subscriptionId
                        env.ARM_TENANT_ID       = json.tenantId
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input 'Approve to apply changes?'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}


