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
        PRIVATE_KEY = '/var/lib/jenkins/portfolio-dev.pem'
        SSH_KEY=/var/lib/jenkins/portfolio-dev.pem
        EC2_USER=ubuntu
        EC2_HOST=18.208.157.79
        REMOTE_DIR=/var/www/html
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
                    //sh "rsync -avrx -e 'ssh -i ${PRIVATE_KEY} -o StrictHostKeyChecking=no' --delete /var/lib/jenkins/workspace/portfolio_ec2/build/ ${EC2_USER}@${EC2_HOST}:/var/www/html"   
                    sh 'scp -i ${SSH_KEY} -r build/* ${EC2_USER}@${EC2_HOST}:${REMOTE_DIR}'               
                }
            }
        }

        stage('Upload to EC2') {
            steps {
                script {
                    sh 'chmod +x upload.sh' // Ensure upload script is executable
                    sh './upload.sh' // Execute upload script
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