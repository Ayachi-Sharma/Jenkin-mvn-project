pipeline{
	agent any

	stages{
		stage('Checkout'){
			steps{
				echo "Checking out source code"
				checkout scm
			}
		}
		stage('Build'){
			steps{
				sh 'mvn clean compile'
			}
		}
		stage('Test'){
			steps{
				sh 'mvn test'
			}
		}
	}
}
