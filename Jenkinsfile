
pipeline {
    agent {
	label 'ass-agent'
	}

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
                echo "Git branch detected: ${env.GIT_BRANCH}"
            }
        }

        stage('Build') {
            steps {
		echo "Using polling"
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

	stage('Archive') {
    		steps {
        		archiveArtifacts artifacts: 'billing-web/target/*.war',
                        fingerprint: true
    		}
	}

    
stage('Deploy') {
    when {
        expression { 
            return env.GIT_BRANCH == 'origin/main' ||
            env.GIT_BRANCH == 'main'}
    }
    steps {
        withCredentials([
            usernamePassword(
                credentialsId: 'tomcat-credentials',
                usernameVariable: 'TOMCAT_USER',
                passwordVariable: 'TOMCAT_PASSWORD'
            )
        ]) {
            sh '''
                set +x
                curl --fail --silent --show-error \
                  --user "$TOMCAT_USER:$TOMCAT_PASSWORD" \
                  --upload-file billing-web/target/billing-web-1.0-SNAPSHOT.war \
                  "http://100.54.143.39:8081/manager/text/deploy?path=/billing-web&update=true"
            '''
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

