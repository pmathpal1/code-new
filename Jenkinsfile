pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'
            args '-v /var/jenkins_home/terraform:/terraform'
        }
    }

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
        LOCATION            = 'eastus'
    }

    stages {
        stage('Clone GitHub Repo') {
            steps {
                git branch: 'main', url: 'git@github.com:pmathpal1/code-new.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var="location=$LOCATION"'
            }
        }

        stage('Terraform Apply') {
            steps {
                input 'Approve to apply changes'
                sh 'terraform apply -var="location=$LOCATION" -auto-approve'
            }
        }
    }
}

