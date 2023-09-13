param([string] $WebServer, [string] $AppName, [string] $BaseHref, [string] $Tag)
npm install
node -max_old_space_size=12000 .//node_modules//@angular//cli//bin//ng build --base-href=$BaseHref --outputPath=C://DevopsFiles//Builds//$WebServer//$Tag//$AppName --configuration=production --output-hashing=all