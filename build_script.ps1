# Script to build .mez file from Power Query (.pq) and PNG (.png) files

# Set the path to the directory where the development files are located
$developmentDirectory = "./JamfPro"

# Set the path to the output .mez file
$outputMEZFile = "./JamfPro.mez"

# Collect all files in the development directory from above
$allFiles = Get-ChildItem -Path $developmentDirectory -Recurse

# Check if any files were found; if not receive error messaging
if ($allFiles.Count -eq 0) {
    Write-Host "No files found in the JamfPro directory to package."
    exit 1
}

# Create a temporary directory to store the files for bundling
$scriptDirectory = (Get-Location).Path
$tempLocation = Join-Path $scriptDirectory "tempFolder"
New-Item -ItemType Directory -Force -Path $tempLocation

# Copy all the files to the temporary directory
foreach ($file in $allFiles) {
    $destinationPath = Join-Path $tempLocation $file.Name
    Copy-Item -Path $file.FullName -Destination $destinationPath
}

# Zip the contents of the temporary directory into a .mez file
$zipFileName = $outputMEZFile
if (-not $zipFileName.EndsWith('.mez')) {
    $zipFileName += '.mez'
}

Compress-Archive -Path $tempLocation\* -DestinationPath $zipFileName -Update

# Clean up the temporary directory
Remove-Item -Path $tempLocation -Force -Recurse

Write-Host "New .mez release packaged successfully: $zipFileName"
