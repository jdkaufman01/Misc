$NixAdmins = "Wessel","Leigh"
$MSAdmins = "Rupprecht","Walstrom","Kaufman","Loats","Riffel"

$StartDate = [datetime]"4/2/2018"
$EndOnCall = $StartDate.AddDays(7)
$i=0
$j=0
$CalendarURL = 'https://kansas.sharepoint.com/teams/IT/Infrastructure/EnterpriseSystems'
$cred = Get-Credential "o365admin@kansas.onmicrosoft.com"

$loadInfo1 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
$loadInfo2 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")


#*************************************
# Conne$Cct to Site and get site lists
#*************************************
$ctx = New-object Microsoft.Sharepoint.client.clientcontext $CalendarURL
$ctx.credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($cred.UserName, $Cred.password)
$web = $ctx.Web
$webs = $web.Webs
$lists = $web.lists
$ctx.load($ctx.site)
$ctx.load($web)
$ctx.load($webs)
$ctx.load($lists)
$ctx.ExecuteQuery()

#*************************************
# Get Calendar
#*************************************
$cal = $web.lists.getbytitle('Calendar')
$ctx.load($cal)
$ctx.ExecuteQuery()

Function Create-OnCallEvent{
param(
    [DateTime]$StartDate,
    [DateTime]$EndDate,
    [String]$Title) 


$listCreationInformation = New-object Microsoft.SharePoint.Client.ListItemCreationInformation
$listitem = $cal.AddItem($listCreationInformation)
$listitem.ParseAndSetFieldValue('Title', $Title)
$listitem.ParseAndSetFieldValue('Description', "")
$listitem.ParseAndSetFieldValue('EventDate', $StartDate)
$listitem.ParseAndSetFieldValue('EndDate', $EndDate)
$listitem.update()
                 
$ctx.load($listitem)
$ctx.ExecuteQuery()
}

Do{
switch ($i){
0 {$i=$i+1}
1 {$i=$i-1}
}

if($j -gt 4){
$j=0
} 


$StartOnCall = $EndOnCall 
Write-Host -ForegroundColor Green "Start on Call @ $StartOnCall"
$Nixadmin = $NixAdmins[$i]
$MSAdmin = $MSadmins[$j]
$OnCall = "$NixAdmin (*NIX) - $MSAdmin (Windows)" 
Write-Host $Oncall
$EndOnCall = $StartOnCall.AddDays(7)
Write-Host -ForegroundColor Yellow "End on Call @ $EndonCall"
$j=$j+1
Create-OnCallEvent -StartDate $StartOnCall -EndDate $EndOnCall -Title $OnCall 

}
Until ($EndonCall -gt [datetime]"1/1/2019")



