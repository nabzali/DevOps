param([string] $ZipName, [string] $Tag)

cd C:\DevopsFiles
hostname
$ZipName

$tagExists = (Test-Path "C:/DevopsFiles/ApplicationBackups/${Tag}" -PathType Container)
if (!$tagExists){
	New-Item -ItemType Directory -Path "C:/DevopsFiles/ApplicationBackups/${Tag}"
}

$pools = Get-IISAppPool

# stop all app pools
foreach ($app in $pools) {
	Write-Output $app.Name #authservice
	Write-Output $app.State #started
	Stop-WebAppPool -Name $app.Name
	Write-Output $app.State #stopped
}

do {} while ((Get-WebAppPoolState | Where-Object { $_.Value -ne "Stopped"}).Count -gt 0)


try {
	
	Compress-Archive -Path "C:\Mazeview\*" -DestinationPath "C:/DevopsFiles/ApplicationBackups/${Tag}/${ZipName}.zip"
}

# ensure all app pools are started
finally {
	foreach ($app in $pools) {
		$state = $app.State
		if ($state -eq "Stopped"){
			Start-WebAppPool -Name $app.Name
		}
	}
	Get-WebAppPoolState #should all have started
}

