pipeline {
    agent any

    environment {
        SVC = 'pl.org.bash.100jokes'
    }

    stages {
        stage('Build') {
            steps {
                sh 'echo "Building image..."'
                dir("service") {
                  echo 'it is service dir'
                  sh 'pwd'
                  sh 'docker-compose up -d'
                  sh 'docker-compose down'
                }
                sh 'echo "Image built"'
            }
        }
        stage('Test') {
            steps {
                sh 'echo "unit test stage"'
            }
        }
        stage('Code quality') {
            steps {
                dir("service") {
                  sh 'echo "code quality check stage"'
                }
            }
        }
        stage('Package') {
            steps {
                sh 'echo "preparing package..."'
                dir("service") {
                  sh 'docker save -o 100jokes-service.tar 100jokes-service:latest'
                }
            }
        }
        stage('Deploy') {
            when {
              expression {
                env.BRANCH_NAME == master
                currentBuild.result == null || currentBuild.result == 'SUCCESS'
              }
            }
            steps {
                input(id: "Run service", message: "Deploy the service?", ok: 'Deploy')
                sh 'docker-compose up -d'
            }
        }

    }
    
    post {
        always {
            archiveArtifacts artifacts: 'service/*.tar', fingerprint: true
        }
    }
}

