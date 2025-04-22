pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ahmedmaged6/petstore:latest'
        TARGET_SERVER_IP = '34.237.77.46'
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
                withCredentials([usernamePassword(credentialsId: 'docker_credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}
                        docker logout
                    '''
                }
            }
        }
    
    stage('Deploy with Ansible') {
            steps {
                echo 'Deploying application using Ansible...'
                withCredentials([
                    usernamePassword(credentialsId: 'docker_credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS'),
                    file(credentialsId: 'ssh_key', variable: 'SSH_KEY')
                ]) {
                    sh '''
                        mkdir -p ~/.ssh
                        cp $SSH_KEY ~/.ssh/id_rsa
                        chmod 600 ~/.ssh/id_rsa
                        ansible-playbook -i ansible/inventory.yml ansible/deploy.yml \
                        --extra-vars "docker_image=$DOCKER_IMAGE docker_user=$DOCKER_USER docker_pass=$DOCKER_PASS target_server_ip=$TARGET_SERVER_IP"
                        rm -f ~/.ssh/id_rsa
                    '''
                }
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
