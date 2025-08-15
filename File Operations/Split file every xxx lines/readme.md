I recently ran in to an issue whilst using CommVault to restore some archive files from it's HSM.

You have to run the gxhsmutility to scan the files to check if any stub files remain, if there is it outputs what is called a map file, you then run the restore again pointing to said map file.
The problem with this was that if the map file was over 100,000 lines the recovery would just crash, so I wrote this to split the map file out in to multiple map files I could then use to recover the data.

![Alt text](screenshot.png?raw=true "Optional Title")

