pipeline {
    agent any
    stages {
        stage('Build Each Project') {
            steps {
                script {                    
                    String[] projects = params['SelectedProjects'].split(',')
                    for (item in projects) {
                        echo "STARTING BUILD FOR " + item + "..."
                        build job: item, parameters: [string(name: 'Tag', value: params['Tag'])]
                    }
                }
            }
        }
    }
}
