param([string] $Tag)
git tag $Tag -m "New Tag: ${Tag}"
git push --tags