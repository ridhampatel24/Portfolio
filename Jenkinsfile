// In this CI/CD setup, the Jenkins pipeline automates the deployment process for a React project hosted on GitHub.
// Triggered by GitHub webhook on a push event, Jenkins builds the React frontend, transfers it to an AWS EC2 instance, and serves it using Nginx.
// This streamlined workflow ensures efficient continuous integration and delivery, allowing for rapid updates and deployments in response to changes in the GitHub repository.

// Required Plugins: SSH Agent plugin, node js, Docker pipeline
// Create Credentials: dockerhub, github
def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline {
    agent any
    tools {
        nodejs "nodeJS"
    }
    environment {
        EC2_HOST = '34.203.31.36'
        EC2_USER = 'ubuntu'
        PRIVATE_KEY = '/var/lib/jenkins/portfolio-dev.pem'
    }

    stages {
        stage('Checkout') {
            steps {
               script {
                    git branch: 'main', url: 'git@github.com:ridhampatel24/Portfolio.git', timeout: 30
                }
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm install && npm run build'
            }
        }
        
        stage('Transfer Frotend Build to EC2') {
            steps {
                script {
                    sh "rsync -avrxqn -e 'ssh -i ${PRIVATE_KEY} -o StrictHostKeyChecking=no' --delete /var/lib/jenkins/workspace/portfolio_ec2/build/ ${EC2_USER}@${EC2_HOST}:/var/www/html"                  
                }
            }
        }
        
    }
    post {
        always {
            echo 'Pipeline succeeded. React app deployed to AWS EC2.'
            slackSend channel: '#jenkinscicd',
            color: COLOR_MAP[currentBuild.currentResult],
            message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }
}