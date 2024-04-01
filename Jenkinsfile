def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline {
    agent any
    tools {
        nodejs "Node-21"
    }

    stages {
        stage('Checkout') {
            steps {
               script {
                    git branch: 'main', url: 'https://github.com/ridhampatel24/Portfolio.git', timeout: 30
                }
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm install && npm run build'
            }
        }
        // stage('Transfer Frotend Build to EC2') {
        //     steps {
        //         script {
        //             sh "rsync -avrx -e 'ssh -i ${PRIVATE_KEY} -o StrictHostKeyChecking=no' --delete /var/lib/jenkins/workspace/portfolio_ec2/build/ ${EC2_USER}@${EC2_HOST}:/var/www/html/ridhampatel.tech"   
        //             //sh 'scp -i ${SSH_KEY} -r build/* ${EC2_USER}@${EC2_HOST}:${REMOTE_DIR}'               
        //         }
        //     }
        // }

        // stage('Upload to EC2') {
        //     steps {
        //         script {
        //             sh 'chmod +x upload.sh' // Ensure upload script is executable
        //             sh './upload.sh' // Execute upload script
        //         }
        //     }
        // }   
        
    }
}