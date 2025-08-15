<### 
.SYNOPSIS
Created by James Lambert
www.roonics.com

.DESCRIPTION
Place all media files in either the root or subfolders of a folder named "files"
The script will process all images first then videos last so videos will be on the last pages created.

.EXAMPLE

.OUTPUTS

.NOTES
###>

##############
# Config
##############

# Image file extensions (used to create thumbnails, if you add to this, make sure to add to $imagefileext2)
    $imagefileext = @('.jpg','.png','.jpeg','.gif','.tiff','.bmp')

# Video file extensions (used to create thumbnails, if you add to this, make sure to add to $videofileext)
   $videofileext = @('.avi','.mp4','.mkv','.mpg','.mpeg','.mov','.wmv','.flv')

# Image file extensions (used to search for files and add to array, if you add to this, make sure to add to $imagefileext)
    $imagefileext2 = @('*.jpg','*.png','*.jpeg','*.gif','*.tiff','*.bmp')

# Video file extensions (used to search for files and add to array, if you add to this, make sure to add to $videofileext2)
    $videofileext2 = @('*.avi','*.mp4','*.mkv','*.mpg','*.mpeg','*.mov','*.wmv','*.flv')

# Folder where pics are located
    $imagefolder ="files\" 

# Number of images per gallery.html
    $newfileevery = "100"

# Gallery filename
    $filenameout = "Gallery"

# Thumbnail width
    $width = "300"

# Thumbnail height
    $height = "250"

# Thumbnail folder
    $thumbnaildir = "Thumbnails"

# Thumbnail quality
    $quality = "75"

# Create image limit number for next link
    $imagelimit = $newfileevery -1

# Style
$css = @' 
<style>
    body
  {
      font-family: Arial; 
      background-color: Gainsboro;
  }

    table, th, td{
      border: 1px solid;
    }

    h1{
        background-color:Tomato;
        color:white;
        text-align: center;
    }
</style>
'@ 

##############
# End config
##############

# Check if pics folder is present
    if (Test-Path -Path $imagefolder) {
        "Thumbnail folder present"
    } else {
           Write-Host "No $imagefolder folder present"
           break
    }

# Create thumbnails folder
    if (Test-Path -Path $thumbnaildir) {
        "Thumbnail folder present"
    } else {
           New-Item -Name $thumbnaildir -ItemType "directory"
    }

# Grab all pics found in folder and sort by name
    $1 = Get-ChildItem -File $imagefolder -recurse -Include $imagefileext2 | Sort-Object Name | % {$_.fullname}

# Grab all vids found in folder and sort by name
    $2 = Get-ChildItem -File $imagefolder -recurse -Include $videofileext2 | Sort-Object Name | % {$_.fullname}

# Join both arrays
    $items = $1 + $2
    $arrayIndex = 0
    $fileIndex = 0

# Set nextpage number
    $fileIndexnext = 1

# Begin loop
    foreach ($i in $items) {
        if ($arrayIndex%$newfileevery -eq 0) 
        {
            $fileIndex++
            $filename = "$filenameout$('{0:d5}' -f $fileIndex).html"  
            add-Content -Path $filename -Value "$css"
        }

# Split path for thumbnail folder
    $thumbnailsplit = Split-Path (Split-Path $i -Parent) -Leaf

# Get file extension of current file
$extn = [IO.Path]::GetExtension($i)

# If file extension matches one in the image extension arry do this
    if ($extn -in $imagefileext )
    {
    $thumbfile = $i + '.thumb.jpg'
    
# Create thumbnail subfolder
    $thumbnaildir2 = $thumbnaildir + '\' + $thumbnailsplit + '\'
    
# Create thumbnail subfolders
    if (Test-Path -Path $thumbnaildir2) {
        "Thumbnail folder present"
    } else {
           New-Item -Name $thumbnaildir2 -ItemType "directory"
    }
    
# Split filename from array and create new file path for thumbnail
    $finalthumb = Split-Path $i -leaf
    $finalthumb2 = $thumbnaildir2 + $finalthumb +'.thumb.jpg'

# Check to see if the thumbnail files is already present in thumbnails folder, if not move created thumbnail, if it is delete created thumbnail
    $FileExists = Test-Path $finalthumb2
    If ($FileExists -eq $True) 
    {
    Write-Host "Thumbnail present skipping move and deleting thumb created"
    # Remove thumbnail
    #Remove-Item $thumbfile
    }
    Else {
    Write-Host "No file at this location, moving thumbnail file"
    # Move thumbnail to thumbnail folder
        magick $i -resize $widthx$height -compress jpeg -quality $quality $finalthumb2
    }

# Add thumbnail and link to full size image to html file
    add-Content -Path $filename -Value "<a href='$i'><img src='$finalthumb2' height='250' width='300' alt='$i'></a>"

# If image reaches limit per page create next gallery link
    if ($arrayIndex%$newfileevery -eq $imagelimit) {
        $fileIndexnext++
        $filename2 = "$filenameout$('{0:d5}' -f $fileIndexnext).html"
        add-Content -Path $filename -Value "<br><center><a href='$filename2'>Next</a></center>"    
    }

# Else if file extension doesnt match any in image array check it against video extension array and do       
    } elseif ($extn -in $videofileext){

    $thumbfile = $i + '.thumb.jpg'
    ffmpeg -ss 00:00:10 -i $i -frames 1 -vf '"select=not(mod(n\,1000)),scale=320:240,tile=2x3"' $thumbfile

# Create thumbnail subfolder
    $thumbnaildir2 = $thumbnaildir + '\' + $thumbnailsplit + '\'
   
# Create thumbnail subfolders
    if (Test-Path -Path $thumbnaildir2) {
        "Thumbnail folder present"
    } else {
           New-Item -Name $thumbnaildir2 -ItemType "directory"
    }

# Split filename from array and create new file path for thumbnail
    $finalthumb = Split-Path $i -leaf
    $finalthumb2 = $thumbnaildir2 + $finalthumb +'.thumb.jpg'

# Check to see if the thumbnail files is already present in thumbnails folder, if not move created thumbnail, if it is delete created thumbnail
    $FileExists = Test-Path $finalthumb2
    If ($FileExists -eq $True) 
    {
    Write-Host "Thumbnail present skipping move and deleting thumb created"
    # Remove thumbnail
    Remove-Item $thumbfile
    }
    Else {
    Write-Host "No file at this location, moving thumbnail file"
    # Move thumbnail to thumbnail folder
        Move-Item -Path $thumbfile -Destination $thumbnaildir2
    }

# Add thumbnail and link to full size image to html file
    add-Content -Path $filename -Value "<a href='$i'><img src='$finalthumb2' height='250' width='300' alt='$i'></a>"

# If image reaches limit per page create next gallery link
    if ($arrayIndex%$newfileevery -eq $imagelimit) {
        $fileIndexnext++
        $filename2 = "$filenameout$('{0:d5}' -f $fileIndexnext).html"
        add-Content -Path $filename -Value "<br><center><a href='$filename2'>Next</a></center>"    
    }


} 

# Increase array count
    $arrayIndex++

}