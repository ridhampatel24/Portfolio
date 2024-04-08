def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline {
    agent any
    tools {
        nodejs "Node-21"
    }

    environment {
        PRIVATE_KEY = '/var/lib/jenkins/ridham-ngnix-keypair.pem'
        EC2_USER = 'ubuntu'
        EC2_HOST = '3.110.160.244'
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
        stage('Transfer Frotend Build to EC2') {
            steps {
                script {
                    sh "rsync -avrx -e 'ssh -i ${PRIVATE_KEY} -o StrictHostKeyChecking=no' --delete /var/lib/jenkins/workspace/ridhampatel.tech_prod/build/ ${EC2_USER}@${EC2_HOST}:/var/www/html/ridhampatel.tech"
                }
            }
        }

        stage('Reload nginx') {
            steps {
                script {
                    def commands = """
                        sudo systemctl reload nginx
                    """
                    sshagent(['ec2-ridham']) {
                        sh "ssh -o StrictHostKeyChecking=no -i ${PRIVATE_KEY} ${EC2_USER}@${EC2_HOST} '${commands}'"
                    }
                }
            }
        }   
        
    }
}
