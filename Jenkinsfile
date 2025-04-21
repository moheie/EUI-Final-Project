pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ahmedmaged6/petstore:latest'
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
                sh '''
                    cd EUI-Final-Project
                    mvn -N io.takari:maven:wrapper
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                sh '''
                    cd EUI-Final-Project
                    ./mvnw clean package -DskipTests
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh '''
                    cd EUI-Final-Project
                    ./mvnw test
                '''
            }
        }

        stage('Dockerize') {
            steps {
                echo 'Building Docker image...'
                sh '''
                    cd EUI-Final-Project
                    docker build -t $DOCKER_IMAGE .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                sh '''
                    cd EUI-Final-Project
                    docker push $DOCKER_IMAGE
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
