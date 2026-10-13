pipeline{
	agent any

	options{
		timeout(time:15, unit:'MINUTES')
	}

	tools{
		jdk 'jdk21'
		maven 'maven3'
	}	

	enviornment{
		APP_NAME = 'invoice-service'
	}

	stages{
		stage('Checkout'){
			steps{
				echo "Checking out source code"
				checkout scm
			}
		}
		stage('Build'){
			steps{
				echo "Building app: ${APP_NAME}"
				sh 'mvn clean compile'
			}
		}
		stage('Test'){
			steps{
				sh 'mvn test'
			}
			post{
				always{
					junit '**/target/surefire-reports/*.xml'
				}
			}
		}
	}
	
		post{
			success{
				echo 'Pipeline completed successfully'	
			}
			failure{
				echo 'Pipeline failed'
			}
		}
}
