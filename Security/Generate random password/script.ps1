<### 
.SYNOPSIS
Created by James Lambert
www.roonics.com

.DESCRIPTION
Generate a random password using powershell

.EXAMPLE

.OUTPUTS

.NOTES

###>

Function random-password ($length = 15)
{
        $punc = 40..60
        $digits = 48..57
        $letters = 65..90 + 97..122
        $password = get-random -count $length `
                -input ($punc + $digits + $letters) |
                        % -begin { $aa = $null } `
                        -process {$aa += [char]$_} `
                        -end {$aa}
        return $password
}

Write-Host "Generating random password and copying to clipboard"
random-password 16 | clip
$text = & {powershell –sta {add-type –a system.windows.forms; [windows.forms.clipboard]::GetText()}}
sleep -m 100
Write-Host "..."
sleep -m 100
Write-Host "..."
Write-Host -ForegroundColor "Green" "$text"