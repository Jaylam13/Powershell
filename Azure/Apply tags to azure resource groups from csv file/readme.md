# Apply tags to azure resource groups from csv file

This script is used to apply tags as per a csv file.
Tags will be applied in uppercase.
If a resource group is present in the csv but not in Azure it will be skipped.
A log file will be generated in the log folder.
A backup of the resource groups previous tags and values will be created in the backup folder.

CSV should be as below and saved as tags.csv in c:\temp\tags unless you specify differently under the config section

+---------------+-------+-------+-------------+

| RESOURCEGROUP | OS    | OWNER | ENVIRONMENT |

|---------------+-------+-------+-------------|

| RG-UKS-Test   | LINUX | JAMES | PRODUCTION  |

+---------------+-------+-------+-------------+

