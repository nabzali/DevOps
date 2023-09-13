param([string] $DbServer, [string] $WebServer, [string] $Tag, [string] $User, [string] $Password)

$PSCred = New-Object System.Management.Automation.PSCredential($User, (ConvertTo-SecureString $Password -AsPlainText -Force))

$webResult = Invoke-Command -ComputerName $WebServer -Credential $PSCred -ScriptBlock {(Get-ChildItem "C:/DevopsFiles/ApplicationBackups//" -Directory | Select-Object -ExpandProperty Name)}
$dbResult =  Invoke-Command -ComputerName $DbServer -Credential $PSCred -ScriptBlock {(Get-ChildItem "C:/DevopsFiles/DatabaseBackups/" -Directory | Select-Object -ExpandProperty Name)}
$uniques = $webResult+$dbResult | Select-Object -Unique
if ($uniques -contains $Tag){
	return $false
}

return $true
