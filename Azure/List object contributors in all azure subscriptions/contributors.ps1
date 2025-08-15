<### 
.Synopsis
Created by James Lambert
www.roonics.com

.DESCRIPTION
This script will connect to Azure and cycle through all subscriptions listing all the objects and who has a role which has
"Contributor" in the name

.EXAMPLE
    Run the script and sign in to Azure

.OUTPUTS
    A file csv file will be created for each subscription named "contribuators_subscription.csv" in c:\temp
    A total number of contributors will be added to the bottom of the csv

.NOTES
    Keep in mind this will only be able to look at subscriptions you have permissions to.
    This will also skip the Visual studio subscription using a if the name like 'visual' statement
###>

###  Config and clear screen
cls
$Path = "C:\Temp\"
$filename = "contributors_"
$headers = "Subscription" + "," + "Resource_name" + "," + "Resource_group" + "," + "Resource_type" + "," + "Display_Name" + "," + "Sign_in_name" + "," + "Role_definition_name" + "," + "Object_type"
$footer = "Total_contributors"

###  Connect to Azure
Connect-AzAccount

###  Get all subscriptions
$getallSubscriptions = Get-AzSubscription
    
###  Loop through subscriptions and get all resources
foreach ($getallSubscription in $getallSubscriptions) {
    Select-AzSubscription $getallSubscription | Out-Null
    $filenamesubscription = $getallSubscription.Name

    ###  Reset counter
    $count = 0

    ###  Skip visual studio subscriptions
    if ($getallSubscription.Name -like '*visual*') {
        Write-host $getallSubscription.Name
        Write-host "Skipping visual studio subscription" -ForegroundColor Yellow
        Write-host ""
    }
    else {

        ###  Check if export file present, if so skip subscription
        $fileToCheck = "$($Path)$filename$filenamesubscription.csv"
        if (Test-Path $fileToCheck -PathType leaf) {
            Write-Host "$path$filename$filenamesubscription.csv File present, skipping." -ForegroundColor Yellow
            Write-host ""
        }
        else {

            ###  Create headers and output file
            Add-content -path "$($Path)$filename$filenamesubscription.csv" -value $headers
                    
            ###  Get all resources
            $resources = Get-AzureRmResource | Select-Object Name, ResourceId, ResourceType, ResourceGroupName

            ###  Loop through each resource and get users/groups where their role has "Contributor" in it
            foreach ($resource in $resources) {
                $items = get-azurermroleassignment -scope $resource.ResourceId | where { $_.RoleDefinitionname -like 'contributor' -and ($_.ObjectType -notcontains 'ServicePrincipal') } |
                Select DisplayName, SignInName, RoledefinitionName, Scope, ObjectType
                    
                ###  Loop through users/groups and get details 
                foreach ($item in $items) {
                    $signinname = $item.SignInName
                    $roledefinitionname = $item.RoledefinitionName
                    $scope = $item.scope
                    $objecttype = $item.ObjectType
                    $sub = $getallSubscription.Name
                    
                    ###  Write output to screen
                    Write-Host $sub "|" $resource.Name "|" $resource.ResourceGroupName "|" $resource.ResourceType "|" $item.DisplayName "|" $signinname "|" $roledefinitionname "|" $objecttype "`n"
                    Write-host $count
                    
                    ###  Write output to csv file
                    $value = $sub + "," + $resource.Name + "," + $resource.ResourceGroupName + "," + $resource.ResourceType + "," + $item.DisplayName + "," + $signinname + "," + $roledefinitionname + "," + $objecttype
                    Add-content -path "$($Path)$filename$filenamesubscription.csv" -value $value  
                    $count ++
                }
            } 
            $value1 = $footer + "," + $count
            Add-content -path "$($Path)$filename$filenamesubscription.csv" -value $value1
        }
    }
}