param([string] $WebServer, [string] $AppName, [string] $Tag, [string] $BuildPath, [string] $User, [string] $Password)

# Export build files to 'Builds_Cache' folder on web server
$webServerShort = $WebServer.Split('.')[0]
$PSCred = New-Object System.Management.Automation.PSCredential($User, (ConvertTo-SecureString $Password -AsPlainText -Force))
$session = New-PSSession -ComputerName $WebServer -Credential $PSCred
Copy-Item -Path "C:\DevopsFiles\Builds\${webServerShort}\${Tag}\${AppName}" -Destination "C:/DevopsFiles/Builds_Cache/${Tag}/${AppName}" -ToSession $session -Recurse -Force


# Then enter web server and copy files across safely
$scriptBlock = {
	param($Tag, $AppName, $BuildPath)
	Stop-Service -Name W3SVC
	do {} until ((Get-Service -Name W3SVC).Status -eq 'Stopped')
	try {
		#Remove existing project folder (overwriting it would not work)
		Remove-Item -Path "${BuildPath}\${AppName}" -Recurse
		
		Move-Item -Path "C:/DevopsFiles/Builds_Cache/${Tag}/${AppName}" -Destination $BuildPath -Force
		Remove-Item -Path "C:/DevopsFiles/Builds_Cache/${Tag}"
	}
	finally{
		Start-Service -Name W3SVC
	}
} 

Invoke-Command -ComputerName $WebServer -Credential $PSCred -ScriptBlock $scriptBlock -ArgumentList $Tag, $AppName, $BuildPath
