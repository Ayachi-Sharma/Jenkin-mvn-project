
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

	
	stage('Docker Build') {
    		steps {
        		echo "Building Docker image for build ${BUILD_NUMBER}"

        	sh '''
            		docker build -t invoice-service:${BUILD_NUMBER} .
        	'''
    		}
	}

	
	stage('Docker Push') {
    		steps {
        		withCredentials([usernamePassword(
            			credentialsId: 'docker-hub',
            			usernameVariable: 'DOCKERHUB_USERNAME',
            			passwordVariable: 'DOCKERHUB_TOKEN'
        		)]) {
            		sh '''
                		set +x
                		echo "$DOCKERHUB_TOKEN" | docker login \
                    			--username "$DOCKERHUB_USERNAME" \
                    			--password-stdin

                		docker tag invoice-service:${BUILD_NUMBER} \
                    			"$DOCKERHUB_USERNAME/invoice-service:${BUILD_NUMBER}"

                		docker push "$DOCKERHUB_USERNAME/invoice-service:${BUILD_NUMBER}"

                		docker logout
            		'''
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
                  "http://100.27.205.230:8081/manager/text/deploy?path=/billing-web&update=true"
            '''
        }
        }
    }
    
    stage('Verify') {
        steps {
            sh '''
                curl --fail --silent --show-error \
                http://100.27.205.230:8081/billing-web/
            '''
        }
    }




    }

    
post {
    failure {
        echo """
        NOTIFICATION: BUILD FAILURE
        Job Name: ${env.JOB_NAME}
        Build Number: ${env.BUILD_NUMBER}
        Build URL: ${env.BUILD_URL}
        """
    }

    fixed {
        echo """
        NOTIFICATION: BUILD FIXED
        Job Name: ${env.JOB_NAME}
        Build Number: ${env.BUILD_NUMBER}
        Build URL: ${env.BUILD_URL}
        """
    }
}

}

