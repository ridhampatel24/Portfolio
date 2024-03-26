// In this CI/CD setup, the Jenkins pipeline automates the deployment process for a React and Node.js project hosted on GitHub.
// Triggered by GitHub webhook on a push event, Jenkins builds the React frontend, transfers it to an AWS EC2 instance, and serves it using Nginx.
// Simultaneously, the Node.js backend is Dockerized, pushed to Docker Hub, and then pulled and run on the EC2 machine. 
// This streamlined workflow ensures efficient continuous integration and delivery, allowing for rapid updates and deployments in response to changes in the GitHub repository.

// Required Plugins: SSH Agent plugin, node js, Docker pipeline
// Create Credentials: dockerhub, github
pipeline {
    agent any
    tools {
        nodejs "nodeJS"
    }
    environment {
        // Define AWS EC2 details
        EC2_HOST = '54.234.146.199'
        EC2_USER = 'ubuntu'
        PRIVATE_KEY = '/var/lib/jenkins/portfolio-dev.pem'
        
        // Define Docker Hub details
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from your Git repository
               script {
                    git branch: 'main', url: 'git@github.com:ridhampatel24/Portfolio.git', timeout: 30
                }
            }
        }

        stage('Build React App') {
            steps {
                // Build React app
                sh 'npm install && npm run build'
            }
        }
        
        stage('Transfer Frotend Build to EC2') {
            steps {
                script {
                      // Optional: Use rsyn to copy the entire folder to the EC2 instance.
                    sh "rsync -avrx -e 'ssh -i ${PRIVATE_KEY} -o StrictHostKeyChecking=no' --delete /var/lib/jenkins/workspace/portfolio_ec2/build/ ${EC2_USER}@${EC2_HOST}:/var/www/html"                  
                }
            }
        }
        
    }
    post {
        success {
            echo 'Pipeline succeeded. React app deployed to AWS EC2.'
        }
        failure {
            echo 'Pipeline failed. Check the logs for errors.'
        }
    }
}