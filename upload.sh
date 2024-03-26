#!/bin/bash

# Define variables
SSH_KEY=/var/lib/jenkins/portfolio-dev.pem
EC2_USER=ubuntu
EC2_HOST=18.208.157.79
REMOTE_DIR=/var/www/html

# Copy build files to EC2 server
scp -i $SSH_KEY -r build/* $EC2_USER@$EC2_HOST:$REMOTE_DIR
