#Requires -Assembly "Microsoft.SharePoint.Client"
$cred = Get-Credential "o365admin@kansas.onmicrosoft.com"

$NixAdmins = "Horvath","Manley","Holman"
$MSAdmins = "Loats","Kaufman","Jackson","Riffel","Alexander"

$StartDate = [datetime]"1/6/2020"
$StartOnCall = $StartDate
$EndOnCall = $StartDate.AddDays(7)
$i=0
$j=0
$CalendarURL = 'https://kansas.sharepoint.com/teams/IT/Infrastructure/EnterpriseSystems'

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
$cal = $web.lists.getbytitle('ITES - OnCall')
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
if($i -gt ($NixAdmins.Length - 1)){
$i=0
}

if($j -gt ($MSAdmins.Length -1)){
$j=0
} 

Write-Host -ForegroundColor Green "Start on Call @ $StartOnCall"
$Nixadmin = $NixAdmins[$i]
$MSAdmin = $MSadmins[$j]
$OnCall = "$NixAdmin (*NIX) - $MSAdmin (Windows)" 
Write-Host $Oncall
$EndOnCall = $StartOnCall.AddDays(7)
Write-Host -ForegroundColor Yellow "End on Call @ $EndonCall"
$i=$i+1
$j=$j+1
Create-OnCallEvent -StartDate $StartOnCall -EndDate $EndOnCall -Title $OnCall 
$StartOnCall = $EndOnCall 

}
Until ($EndonCall -gt [datetime]"6/1/2020")
