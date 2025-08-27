pipeline {
  agent any

  environment {
    // These should be set as Jenkins credentials (Secret Text or similar)
    ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
    ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
    ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
    ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
  }

  stages {
    stage('Debug Env') {
      steps {
        // Check if ARM env variables are available
        sh 'env | grep ARM || echo "ARM vars not set"'
      }
    }

    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        script {
          docker.image('hashicorp/terraform:latest').inside {
            sh 'terraform init'
          }
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        script {
          docker.image('hashicorp/terraform:latest').inside {
            sh 'terraform plan -out=tfplan'
          }
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        input message: 'Approve Terraform Apply?'
        script {
          docker.image('hashicorp/terraform:latest').inside {
            sh 'terraform apply -auto-approve tfplan'
          }
        }
      }
    }
  }

  post {
    always {
      echo "Cleaning up workspace"
      deleteDir()
    }
  }
}
