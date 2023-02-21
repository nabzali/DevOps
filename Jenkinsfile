pipeline {
    agent any
    stages { 
        stage('Full Mazeiew Application Backup (if applicable)') {
            // Done here because we cannot run a full backup when running the individual jobs
            when {
                expression { params['SelectionType' == "Select All Projects" }
            }
            steps {
                script {
                    powershell """
                        Enter-PSSession -ComputerName mpstageweb.tc.mazepoint.local -Credential svc_jenkins
                        cd C:\\Mazeview
                        Get-WebAppPool | Stop-WebAppPool
                        Compress-Archive -Path .\* -DestinationPath C:\\Users\\svc_jenkins\\Documents\\BackupFiles\\${appName}_${timestamp}.zip
                        Get-WebAppPool | Start-WebAppPool
                    """
                }
            }
        }
        stage('Build Each Project') {
            steps {
                script {
                    
                    String[] projects = params['SelectedProjects'].split(',')
                    for (item in projects) {
                        echo "STARTING BUILD FOR " + item + "..."
                        build job: item, parameters: [string(name: 'Tag', value: params['Tag']),
                                                      string(name: 'Environment', value: params['Environment']),
                                                      string(name: 'SelectionType' value: params['SelectionType'])]
                    }
                }
            }
        }
    }
}
