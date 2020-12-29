$ErrorActionPreference = 'Stop'
$gameName = "EasyModeStore"
$version = "v1.0.2"
$requiredFiles = @('manifest.json', 'shops.json', 'readme.txt')

################################################################

$publishDir = [IO.Path]::Combine($pwd, "publish")

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
