<### 
.SYNOPSIS
Created by James Lambert
www.roonics.com

.DESCRIPTION
Stop and disable a Windows service using powershell

Populate "computers.txt" with all the server names you wish this to run on then adjust the script to fit the service you require.

.EXAMPLE

.OUTPUTS

.NOTES

###>

$SrvNames = Get-Content -Path 'C:\data\scripts\computers.txt'

foreach ($Server in $SrvNames)
{
	Get-Service -Name "Rubrik Backup Service" -ComputerName $Server | Stop-Service -PassThru | Set-Service -StartupType disabled
}