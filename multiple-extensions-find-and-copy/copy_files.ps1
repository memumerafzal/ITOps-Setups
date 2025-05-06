# copy_files.ps1
# Script to copy files with specific extensions from a source to a destination folder

# Define source and destination paths
$sourcePath = "C:\inetpub\wwwroot\fitripm\HL7\Files\outbound"
$destinationPath = "D:\Lockboxfolder"
$logPath = "C:\CopyLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# List of file extensions to copy
$extensions = @(
    "*.drv", "*.uxz", "*.0mc", "*.kzs", "*.yua", "*.kji", "*.0w4", "*.kdg", "*.dnu", "*.s5b",
    "*.hku", "*.nsf", "*.rjf", "*.3vm", "*.tlt", "*.zkt", "*.xur", "*.glj", "*.x4b", "*.1h3",
    "*.mdn", "*.2rb", "*.nkf", "*.lgt", "*.cqh", "*.wrc", "*.okz", "*.uby", "*.2te", "*.asc",
    "*.2vy", "*.w3b", "*.gsb", "*.bdb", "*.4tf", "*.w5p", "*.rky", "*.lug", "*.bcf", "*.sat",
    "*.reg", "*.ryf", "*.yx5", "*.qto", "*.dzb", "*.uy5", "*.meq", "*.vlk", "*.hlt", "*.xx2",
    "*.45k", "*.hfi", "*.kom"
)

# Ensure the destination folder exists
try {
    if (-not (Test-Path -Path $destinationPath)) {
        New-Item -Path $destinationPath -ItemType Directory -Force | Out-Null
        "Created destination folder: $destinationPath" | Out-File -FilePath $logPath -Append
    }
} catch {
    "Error creating destination folder: $_" | Out-File -FilePath $logPath -Append
    Write-Error "Failed to create destination folder: $_"
    exit 1
}

# Copy files with specified extensions
try {
    $files = Get-ChildItem -Path $sourcePath -Include $extensions -Recurse -ErrorAction Stop
    $fileCount = 0

    foreach ($file in $files) {
        try {
            Copy-Item -Path $file.FullName -Destination $destinationPath -Force -ErrorAction Stop
            $fileCount++
            "Copied: $($file.FullName) to $destinationPath" | Out-File -FilePath $logPath -Append
        } catch {
            "Error copying $($file.FullName): $_" | Out-File -FilePath $logPath -Append
        }
    }

    "Successfully copied $fileCount files to $destinationPath" | Out-File -FilePath $logPath -Append
    Write-Host "Completed: Copied $fileCount files. Check log at $logPath"
} catch {
    "Error during file copy operation: $_" | Out-File -FilePath $logPath -Append
    Write-Error "Failed to copy files: $_"
    exit 1
}