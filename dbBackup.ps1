param([string] $DbServer, [string] $DbName, [string] $Tag, [string] $Timestamp, [string] $User, [string] $Password)

$PSCred = New-Object System.Management.Automation.PSCredential($User, (ConvertTo-SecureString $Password -AsPlainText -Force))

$scriptBlock = {
	param($ServerName, $DbName, $Tag, $FileName)
	$tagExists = (Test-Path "C:/DevopsFiles/DatabaseBackups/${Tag}" -PathType Container)

	if (!$tagExists){
		New-Item -ItemType Directory -Path "C:/DevopsFiles/DatabaseBackups/${Tag}"
	}


	Backup-SqlDatabase -ServerInstance $ServerName -Database $DbName -BackupFile "C:/DevopsFiles/DatabaseBackups/${Tag}/${FileName}.bak"
} 

Invoke-Command -ComputerName ${DbServer} -Script $scriptBlock -Credential $PSCred -ArgumentList ${DbServer}, ${DbName}, ${Tag}, ${DbName}_${Timestamp}