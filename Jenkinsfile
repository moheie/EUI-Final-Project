pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'moheie/jpetstore'
        TARGET_SERVER_IP = '54.160.125.134'
        DOCKER_CREDENTIALS = credentials('docker_credentials') // Binds to DOCKER_CREDENTIALS_USR and DOCKER_CREDENTIALS_PSW
        SSH_KEY = credentials('ssh_key') 
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo 'Cloning the source code...'
                git branch: 'test', url: 'https://github.com/moheie/EUI-Final-Project'
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
                sh "docker build -t ${DOCKER_HUB_REPO}:build-${BUILD_NUMBER} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Logging into Docker Hub and pushing image...'
                sh '''
                    echo "Docker username: $DOCKER_CREDENTIALS_USR"
                    echo "$DOCKER_CREDENTIALS_PSW" | docker login -u "$DOCKER_CREDENTIALS_USR" --password-stdin
                    docker push ${DOCKER_HUB_REPO}:build-${BUILD_NUMBER}
                    docker logout
                '''
            }
        }

        stage('Deploy with Ansible') {
            steps {
                echo 'Deploying application using Ansible...'
                sh '''
                    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.yml ansible/deploy.yml \
                    --extra-vars "\
                        docker_image=${DOCKER_HUB_REPO}:build-${BUILD_NUMBER} \
                        docker_user=$DOCKER_CREDENTIALS_USR \
                        docker_pass=$DOCKER_CREDENTIALS_PSW \
                        target_server_ip=$TARGET_SERVER_IP \
                        ssh_key=$SSH_KEY"                
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            //cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
