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
                String[] projects = params['SelectedProjects']
                echo projects
                //String[] list = selections.split(',');
                //for (project in list)
                //{
                //    build project   
                //}
            }
        }
    }
}
