# Create html galleries of images and videos


This script is designed to be placed in a folder with lots of images and videos including subfolders, create thumbnails of all the images found and uses ffmpeg to create frame sheets for movies then add 100 per HTML page with a "Next" link at the bottom linking to the next gallery page.

Make sure to adjust the settings in the config section to suit your needs.

### Prerequisites
1. Download ffmpeg from https://ffmpeg.org/download.html#build-windows, unzip and copy the contents to c:\ffmpeg

2. Add the ffmpeg folder as a path, as per below.

![Alt text](screenshot01.png?raw=true "Optional Title")

3. Download and install ImageMagick and ensure the "add to systm path" is ticked during the installation. https://imagemagick.org/index.php

4. Place your images, videos in "Files" directory

5. ffmpeg seems to have issues with certain special characters so ensure there aren't any in the video filenames


See screenshots for examples.

![Alt text](screenshot02.png?raw=true "Optional Title")
![Alt text](screenshot03.png?raw=true "Optional Title")
![Alt text](screenshot04.png?raw=true "Optional Title")