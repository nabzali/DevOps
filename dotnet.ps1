param([string] $WebServer, [string] $AppName, [string] $Tag, [string] $User, [string] $Password)

$appNameLower = $AppName.ToLower()
$PSCred = New-Object System.Management.Automation.PSCredential($User, (ConvertTo-SecureString $Password -AsPlainText -Force))
dotnet restore "${AppName}.sln" -v n
dotnet build "${AppName}.sln" -v n --configuration Release -o "C:\DevopsFiles\Builds\${WebServer}\${Tag}\${appNameLower}"
