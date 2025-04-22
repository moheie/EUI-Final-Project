pipeline {
    agent any

    environment {
        TARGET_SERVER_IP = '34.237.77.46'
        DOCKER_IMAGE = 'ahmedmaged6/petstore:latest'
        DOCKER_USER = credentials('docker_credentials')
        DOCKER_PASS = credentials('docker_credentials') 
        SSH_KEY = credentials('ssh_key') 
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo 'Cloning the source code...'
                git branch: 'main', url: 'https://github.com/ahmedmaged6/EUI-Final-Project'
            }
        }

        stage('Setup Maven Wrapper') {
            steps {
                echo 'Setting up Maven wrapper...'
                sh 'mvn -N io.takari:maven:wrapper'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh './mvnw test'
            }
        }

        stage('Dockerize') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Logging into Docker Hub and pushing image...'
                sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push ${DOCKER_IMAGE}
                    docker logout
                '''
            }
        }

        stage('Deploy with Ansible') {
            steps {
                echo 'Deploying application using Ansible...'
                sh '''
                    mkdir -p ~/.ssh
                    cp $SSH_KEY ~/.ssh/id_rsa
                    chmod 600 ~/.ssh/id_rsa
                    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.yml ansible/deploy.yml \
                    --extra-vars "docker_image=$DOCKER_IMAGE docker_user=$DOCKER_USER docker_pass=$DOCKER_PASS target_server_ip=$TARGET_SERVER_IP"
                    rm -f ~/.ssh/id_rsa
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
