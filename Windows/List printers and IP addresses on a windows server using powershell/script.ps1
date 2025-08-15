<### 
.SYNOPSIS
Created by James Lambert
www.roonics.com

.DESCRIPTION
Collect port names and host addresses into hash table


.EXAMPLE

.OUTPUTS

.NOTES

###>

$hostAddresses = @{}
Get-WmiObject Win32_TCPIPPrinterPort | ForEach-Object {
  $hostAddresses.Add($_.Name, $_.HostAddress)
}

Get-WmiObject Win32_Printer | ForEach-Object {
  New-Object PSObject -Property @{
    "Name" = $_.Name
    "DriverName" = $_.DriverName
    "Status" = $_.Status
    "HostAddress" = $hostAddresses[$_.PortName]
    
  }
}