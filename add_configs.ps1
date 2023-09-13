param([string] $Server, [string] $AppName, [string] $Environment, [string] $Tag)

$map = @{
	Stage = "ci";
	UAT = "uat";
	Production = "production"
}
$newEnv = $map[$Environment]

$appNameLower = $AppName.ToLower()

# we have cloned config repo to current dir
$source = $PWD.Path

# (devops machine) config items are copied to the build (before being exported)
Copy-Item "${source}\Files\${AppName}\$newEnv\*" -Destination "C:/DevopsFiles/Builds/${Server}/${Tag}/${appNameLower}"