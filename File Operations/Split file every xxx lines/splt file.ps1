<### 
.SYNOPSIS
Created by James Lambert
www.roonics.com

.DESCRIPTION
This script will get a list of all files in the "Files_to_split folder" then loop through each file and split
every XXX numbers of lines (set in the config)

.EXAMPLE

.OUTPUTS

.NOTES

###>

###  Config
$FilesToSplitDir = "Files_to_split\"
$SplitFilesDir = "Split_files\"
$SplitFileLines = 100000
$padding = "       "

cls

###  Check if source folder is present
if (!(Test-Path -Path $FilesToSplitDir)) {
    Write-Host "ERROR - $FilesToSplitDir folder not present" -ForegroundColor Red
    break
}

###  Check if destination folder is present
if (!(Test-Path -Path $SplitFilesDir)) {
    Write-Host "ERROR - $SplitFilesDir folder not present" -ForegroundColor Red
    break
}

###  Check source folder is empty
if ( (Get-ChildItem $FilesToSplitDir | Measure-Object).Count -eq 0) {
    Write-host "No files found to split" -ForegroundColor Red
    break
}

###  Check If destination folder has files present if so stop
if ( (Get-ChildItem $SplitFilesDir | Measure-Object).Count -ne 0) {
    Write-Host "File detected in destination folder." -ForegroundColor Red
    break
}
else {
       
    ###  Get list of files to split
    $FilesToSplits = Get-ChildItem -Path $FilesToSplitDir

    ###  Loop through files in dir and split them
    foreach ($filesToSplit in $FilesToSplits) {
        Write-Host "Splitting -"$FilesToSplit -ForegroundColor Green
        $i = 0
        Get-Content $FilesToSplitDir$FilesToSplit -ReadCount $SplitFileLines | % { $i++; Write-Host $padding$SplitFilesDir$i"_"$FilesToSplit; $_ | Out-File $SplitFilesDir$i"_"$FilesToSplit -Encoding utf8}
    }
}