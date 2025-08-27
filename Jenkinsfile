pipeline {
  agent any
  environment {
    ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
    ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
    ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
    ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
  }
  stages {
    stage('Print ARM Vars') {
      steps {
        sh '''
          echo "ARM_TENANT_ID: $ARM_TENANT_ID"
          echo "ARM_SUBSCRIPTION_ID: $ARM_SUBSCRIPTION_ID"
          echo "ARM_CLIENT_ID: $ARM_CLIENT_ID"
          echo "ARM_CLIENT_SECRET: ${ARM_CLIENT_SECRET:0:4}****"
        '''
      }
    }
  }
}
