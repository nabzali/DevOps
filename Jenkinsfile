def timestamp = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
def tag = params['Tag']
def map = [:]
def webServer = ""
def dbServer = ""

pipeline {
    agent any
    environment {
    	CRED = credentials("${JENKINS_CRED}")
    }
    stages {
      	stage("Reading Project Information From devops.json File") {
            steps {
              script {
                  
                  // Read JSON from disk
                  def json = readJSON file: './devops.json'
                
                  // Store source data in global map variable
                  json.each { key, value ->
                    echo "${key}, ${value}"
                    map[key] = value
                    if (map[key].isEmpty()) {
                        error "Build failed. The value for ${key} is null."
                    }
                    
                  }
                  webServer = map["webServer"][params['Environment']]
                  dbServer = map["dbServer"][params['Environment']]
                  
                  if (tag.isEmpty()){
                    tag = "Staging_Backups" 
                  }
              }
            }
        }
      
        stage('Cloning Git Repo') {
            steps {
                git branch: params['Branch'], credentialsId: "${GIT_CRED}", url: map["gitURL"]     
            }
        }
      
      	stage("Build") {
            steps {
                script {
                  powershell(script: "C:\\DevopsFiles\\dotnet.ps1 ${webServer.split("\\.")[0]} ${map["appName"]} ${tag} \$env:CRED_USR \$env:CRED_PSW")                     
                  	
                }
            }
        }
                     
      	stage("Database Backup") { //not required in npm projects or projects without a db
            steps {
                script {
                  powershell(script: "C:\\DevopsFiles\\dbBackup.ps1 ${dbServer} ${map["dbName"]} ${tag} ${timestamp} \$env:CRED_USR \$env:CRED_PSW")
                }
            }
        }

        stage("Deployment Backup") {
          
          	when {
                expression { params['SelectionType'] == "Custom Selection" }
            }
            steps {
                script {
                  	powershell(script: "C:\\DevopsFiles\\appBackup.ps1 ${webServer} ${map["appName"].toLowerCase()} ${tag} ${timestamp} \$env:CRED_USR \$env:CRED_PSW")
                }
            }
        }
      
      	stage("Export Build Files") {
            steps {
                script {	
                  	dir("config-files"){
                        git branch: "master", credentialsId: "${GIT_CRED}", url: "${CONFIGS_URL}"
                      	powershell(script: "C:\\DevopsFiles\\add_configs.ps1 ${webServer.split("\\.")[0]} ${map["appName"]} ${params['Environment']} ${tag}")
                  	}
                  	powershell(script: "C:\\DevopsFiles\\export_build_files.ps1 ${webServer} ${map["appName"].toLowerCase()} ${tag} ${map["buildPath"]} \$env:CRED_USR \$env:CRED_PSW")     
                }
            }
        }

        stage("Tagging the Branch") {
            when {
                expression { !tag.isEmpty() && tag != "Staging_Backups"}
            }   
            steps {
                script {
                  	powershell(script: "C:\\DevopsFiles\\tag.ps1 ${tag}")
                }
            }
        }          
      
    }
}
