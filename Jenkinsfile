
pipeline {
    agent any

    parameters {
        string(
            name: 'RELEASE_NOTES',
            defaultValue: 'Initial release - billing application',
            description: 'Enter release notes for this build'
        )
    }

    options {
        timeout(time: 15, unit: 'MINUTES')
    }

    tools {
        jdk 'jdk21'
        maven 'maven3'
    }

    environment {
        APP_NAME = 'invoice-service'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out source code"
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Release Notes: ${params.RELEASE_NOTES}"
                echo "Building app: ${APP_NAME}"
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn verify'
            }
            post {
                always {
                    junit '**/target/failsafe-reports/*.xml'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}

