<### 
.SYNOPSIS
Created by James Lambert
www.roonics.com

.DESCRIPTION
This allows you to add a randomly generated number to the prefix of a bunch of files.
In the below example we are adding a random prefix to every *.jpg file.

.EXAMPLE

.OUTPUTS

.NOTES

###>

$files = Get-ChildItem "C:\temp\files" -Filter *.jpg
foreach ($file in $files) {
	$prefix = Get-Random
	$newFileName = "${prefix}_${file}"
	Rename-Item $file $newFileName
}