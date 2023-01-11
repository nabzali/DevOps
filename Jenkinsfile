pipeline {
    agent any
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Build Each Project') {
            steps {               
                echo params['SelectedProjects']
            }
        }
    }
}
