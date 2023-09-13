param([string] $DbServer, [string] $WebServer, [string] $Tag, [string] $User, [string] $Password)

$PSCred = New-Object System.Management.Automation.PSCredential($User, (ConvertTo-SecureString $Password -AsPlainText -Force))

$dbRestoreScript = {
	param([string] $ServerName, [String] $Tag)
	#Import-Module SqlServer

	$dbExists = (Test-Path "C:/DevopsFiles/DatabaseBackups/${Tag}" -PathType Container)
	if (!$dbExists){
		return "Database restore skipped - no database backup found under the tag '${Tag}'."
	}

	$files = Get-ChildItem "C:/DevopsFiles/DatabaseBackups/${Tag}" | ForEach-Object { $_.Name }

	foreach ($file in $files){
		$dbName = $file.Substring(0, $file.LastIndexOf("_"))
		Invoke-SqlCmd -ServerInstance $ServerName -Query "ALTER DATABASE [${dbName}] SET OFFLINE WITH ROLLBACK IMMEDIATE;"
		Restore-SqlDatabase -ServerInstance $ServerName -Database $dbName -BackupFile "C:/DevopsFiles/DatabaseBackups/${Tag}/${file}" -ReplaceDatabase -Verbose
		Invoke-SqlCmd -ServerInstance $ServerName -Query "ALTER DATABASE [${dbName}] SET ONLINE;"
	}
	
}

$appRestoreScript = {
	param([string] $Server, [string] $Tag)
	$files = Get-ChildItem "C:/DevopsFiles/ApplicationBackups/${Tag}" | ForEach-Object { $_.Name }
	Stop-Service -Name W3SVC
	try {
		foreach ($zip in $files){
			Expand-Archive -Path "C:/DevopsFiles/ApplicationBackups/${Tag}/${zip}" -DestinationPath "C:/Mazeview" -Force -Verbose
		}
	}
	finally{
		Start-Service -Name W3SVC
	}	
}


Invoke-Command -ComputerName ${DbServer} -Script $dbRestoreScript -Credential $PSCred -ArgumentList ${DbServer}, ${Tag}
Invoke-Command -ComputerName ${WebServer} -Script $appRestoreScript -Credential $PSCred -ArgumentList ${DbServer}, ${Tag}