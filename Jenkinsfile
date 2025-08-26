pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'   // Docker image for Terraform
            args '-v /var/jenkins_home/terraform:/terraform'   // Mount volume to persist state
        }
    }
    environment {
    ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
    ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
    ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
    ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
  }

    environment {
        AZURE_LOCATION = "East US"
    }

    stages {
        stage('Clone GitHub Repo') {
            steps {
                git 'git@github.com:pmathpal1/code-new.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'  // Initializes Terraform
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'  // Generates an execution plan
            }
        }

        stage('Terraform Apply') {
            steps {
                input 'Approve to apply changes'  // Pause for manual approval before applying changes
                sh 'terraform apply -auto-approve'  // Apply the configuration automatically
            }
        }
    }
}
// this is the comment