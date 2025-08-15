<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.OUTPUTS

.NOTES

#>

# SET DATE FORMAT
$DateTime = $(get-date -f yyyy-MM-dd_HH-mm-ss)

# START TRANSCRIPT LOGGING
Start-Transcript -Path "log_$DateTime.txt" -Append



Write-Host "Script stuff here"



# STOP TRANSCRIPT LOGGING
Stop-Transcript