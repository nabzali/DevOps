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
                String selections = params['Select-Projects-To-Build']
                String[] selectionsList = selections.split(',');
                for (project in selectionsList)
                {
                    build project   
                }
            }
        }
    }
}
