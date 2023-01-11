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
                String projects = params['SelectedProjects'].split(',')
                for (item in projects) {
                    echo item
                }
            }
        }
    }
}
