$ErrorActionPreference = 'Stop'
$gameName = "EasyModeStore"
$requiredFiles = @('manifest.json', 'shops.json', 'readme.txt')

################################################################

# Delete old artifacts
Remove-Item *.zip

$publishDir = [IO.Path]::Combine($pwd, "publish")

# get version
$manifestFile = [System.IO.File]::ReadAllText("manifest.json") | ConvertFrom-Json
$version = $manifestFile.Version

write-host "Version $version"

$zipsPath = [IO.Path]::Combine(".", "*.zip")
remove-item $zipsPath

$zipFile = "$gameName-$version.zip"

if (Test-Path($publishDir))
{
    Remove-Item $publishDir -Recurse
}

New-Item -Path $publishDir -ItemType Directory

# Copy all content over
foreach ($file in $requiredFiles)
{
    Copy-Item $file $publishDir
}

# Zip it up
if (Test-Path($zipFile))
{
    Remove-Item $zipFile -Force
}

Add-Type -A 'System.IO.Compression.FileSystem'
[IO.Compression.ZipFile]::CreateFromDirectory($publishDir, $zipFile);
Write-Host DONE! Zipped to $zipFile
