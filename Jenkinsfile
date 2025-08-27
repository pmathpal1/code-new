pipeline {
    agent any
    environment {
        ARM_TENANT_ID = credentials('arm-tenant-id')
    }
    stages {
        stage('Check Credential') {
            steps {
                script {
                    if (env.ARM_TENANT_ID) {
                        echo "Credential ARM_TENANT_ID is accessible."
                    } else {
                        error "Credential ARM_TENANT_ID is NOT accessible."
                    }
                }
            }
        }
    }
}
