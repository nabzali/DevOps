param([string] $WebServer, [string] $AppName, [string] $Tag, [string] $Timestamp, [string] $User, [string] $Password)

$PSCred = New-Object System.Management.Automation.PSCredential($User, (ConvertTo-SecureString $Password -AsPlainText -Force))

$scriptBlock = {
	param([string] $Project, [string] $ZipName, [string] $Tag)

	$appPoolStopped = $false

	$tagExists = (Test-Path "C:/DevopsFiles/ApplicationBackups/${Tag}" -PathType Container)

	if (!$tagExists) {
		New-Item -ItemType Directory -Path "C:/DevopsFiles/ApplicationBackups/${Tag}"
	}

	# Easier to turn off IIS?
	
	$website = Get-IISAppPool

	foreach ($item in $website){
		if ($item.Name -eq $Project){
			Write-Output "match"
			Stop-WebAppPool $Project
			$appPoolStopped = $true
			do {} until ((Get-WebAppPoolState $Project).Value -eq "Stopped")
			break
		}
	}

	try {
		
		# Back up the files
		Compress-Archive -Path "C:/Mazeview/${Project}" -DestinationPath "C:/DevopsFiles/ApplicationBackups/${Tag}/${ZipName}.zip"
	}

	finally {
		if ($appPoolStopped){
			Start-WebAppPool $Project
			$appPoolStopped = $false
		}
	}
}

Invoke-Command -ComputerName ${WebServer} -Script $scriptBlock -Credential $PSCred -ArgumentList ${AppName}, ${AppName}_${Timestamp}, ${Tag}