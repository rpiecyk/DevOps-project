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
                sh 'echo "unit test"'
            }
        }
        stage('Code quality') {
            steps {
                dir('${env.CODE_DIR}') {
                  sh 'echo "code quality check"'
                }
            }
        }
        stage('Package') {
            steps {
                sh 'echo "preparing package..."'
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
                input(id: "Run service", message: "Deploy ${env.SVC}?", ok: 'Deploy')
                sh 'docker-compose up -d'
            }
        }

    }
    post {
        always {
             node('master') {
                 lastChanges()
             }
        }
    }
}

