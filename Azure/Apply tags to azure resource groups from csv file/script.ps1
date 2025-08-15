<#
.SYNOPSIS
Created by James Lambert
www.roonics.com

.DESCRIPTION
This script is used to apply tags as per a csv file.
Tags will be applied in uppercase.
If a resource group is present in the csv but not in Azure it will be skipped.
A log file will be generated in the log folder.
A backup of the resource groups previous tags and values will be created in the backup folder.

.EXAMPLE
CSV should be as below and saved as tags.csv in c:\temp\tags unless you specify differently under the config section

+---------------+-------+-------+-------------+
| RESOURCEGROUP | OS    | OWNER | ENVIRONMENT |
|---------------+-------+-------+-------------|
| RG-UKS-Test   | LINUX | JAMES | PRODUCTION  |
+---------------+-------+-------+-------------+

.OUTPUTS

.NOTES

#>

##
# CONFIG START
##
$TargetSubscription = "Name of your subscription here"
$Path = "C:\temp\tags\"
$CSVFile = "tags.csv"
$BackupFolder = "Backups\"
$LogFileFolder = "Logs\"
##
# CONFIG END
# DO NOT EDIT PAST THIS LINE
##

# SET PATHS FOR BACKUP AND LOG FOLDER
$PathBackups = $Path + $BackupFolder
$PathLogs = $Path + $LogFileFolder

# START TRANSCRIPT LOGGING
Start-Transcript -Path $PathLogs"log_"$(get-date -f yyyy-MM-dd_HH-mm-ss)".txt" -Append

# CLEAR SCREEN
cls

# CHECK $Path FOLDER IS PRESENT
if (!(Test-Path -Path $Path)) {
       Write-Host "ERROR - $Path folder not present" -ForegroundColor Red
       break
    }

# CHECK $PathBackups FOLDER IS PRESENT, IF NOT CREATE IT
if (!(Test-Path -Path $PathBackups)) {
        Write-Host "ERROR - $PathBackups folder not present" -ForegroundColor Red
        New-Item -Path $Path -Name $BackupFolder -ItemType "directory"
        Write-Host "INFO - $PathBackups Created" -ForegroundColor Blue
    }

# CHECK $PathLogs FOLDER IS PRESENT, IF NOT CREATE IT
if (!(Test-Path -Path $PathLogs)) {
    Write-Host "ERROR - $PathLogs folder not present" -ForegroundColor Red
    New-Item -Path $Path -Name $LogFileFolder -ItemType "directory"
    Write-Host "INFO - $PathLogs Created" -ForegroundColor Blue
}

# CHECK $CSVFile FILE IS PRESENT
$CSVFilePath = $Path + $CSVFile
if (!(Test-Path -Path $CSVFilePath)) {
        Write-Host "ERROR - $CSVFilePath file not present" -ForegroundColor Red
        break
    }

# CONNECT TO AZURE
Connect-AzAccount | Out-Null

# SELECT SUBSCRIPTION
Select-AzSubscription $TargetSubscription
Write-Host "INFO - $TargetSubscription Subscription selected" -ForegroundColor Blue
Write-Host ""

# IMPORT CSV
$Import = Import-Csv -Path $Path$CSVFile 

# FOR EACH ITEM IN CSV
foreach($I in $Import) {

    # CHECK IF RESOURCE GROUP IN CSV IS PRESENT IN AZURE
    Get-AzResourceGroup -Name $I.RESOURCEGROUP -ErrorVariable notPresent -ErrorAction SilentlyContinue | Out-Null
    Write-Host ""$I.RESOURCEGROUP"" -ForegroundColor Green
    Write-Host "INFO - Checking"$I.RESOURCEGROUP"resource group is present" -ForegroundColor Blue
    if ($notPresent){

    # IF RESOURCE GROUP NOT PRESENT
        Write-Host "ERROR -"$I.RESOURCEGROUP"resource Group not present" -ForegroundColor Red
        Write-Host ""
    }else{

    # IF RESOURCE GROUP PRESENT BACKUP OLD TAGS
    Write-Host "INFO -"$I.RESOURCEGROUP"resource group is present" -ForegroundColor Blue
    $Resource = Get-AzResourceGroup -Name $I.RESOURCEGROUP
    $ResourceGroupLog=$I.RESOURCEGROUP+" - $(get-date -f yyyy-MM-dd_HH-mm-ss)"+".log"
    Write-Host "INFO - Creating backup file for"$I.RESOURCEGROUP"resource group" -ForegroundColor Blue
    Get-AzTag -ResourceId $Resource.ResourceId | Out-File -FilePath $PathBackups$ResourceGroupLog 
    Write-Host "INFO - Writing old tags and values to $ResourceGroupLog log file" -ForegroundColor Blue

    # CONVERT CSV TAG VALUES TO UPPERCASE
    $Os=$I.Os.ToUpper()
    $Owner=$I.Owner.ToUpper()
    $Environment=$I.Environment.ToUpper()

    # APPLY TAGS
    $Tags = @{"OS"="$Os"; "OWNER"="$Owner"; "ENVIRONMENT"="$Environment"}
    Update-AzTag -ResourceId $Resource.ResourceId $Tags -Operation Merge | Out-Null
    Write-Host "INFO - Writing CSV Tags and values OS=$Os, OWNER=$Owner, ENVIRONMENT=$Environment to"$I.RESOURCEGROUP"resource group" -ForegroundColor Blue
    Write-Host ""
    }
}

# STOP TRANSCRIPT LOGGING
Stop-Transcript