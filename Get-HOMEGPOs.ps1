$csvlocation = Read-Host -Prompt "Enter location of csv containing workstationous"
#Get Workstation OUs 
$workstationOUs = import-csv ($csvlocation) -Header OU

function IsNotLinked($xmldata){ 
    If ($xmldata.GPO.LinksTo -eq $null) { 
        Return $true 
    } 
     
    Return $false 
} 

#Set LinkedGPOs variable
$linkedGPOS = @() 
$unlinkedGPOs = @() 
#Get Unliked GPOs
Get-GPO -All | ForEach { 
    $gpo = $_ ; $_ | Get-GPOReport -ReportType xml | ForEach { 
        If(IsNotLinked([xml]$_)){$unlinkedGPOs += $gpo} 
    }
} 
#Get Linked GPOs 

Foreach ($workstationOU in $workstationOUs){

$GetLinkedGPOs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' -SearchBase $workstationOU.OU | select -ExpandProperty LinkedGroupPolicyObjects            
$GUIDRegex = "{[a-zA-Z0-9]{8}[-][a-zA-Z0-9]{4}[-][a-zA-Z0-9]{4}[-][a-zA-Z0-9]{4}[-][a-zA-Z0-9]{12}}"            
            
foreach($LinkedGPO in $GetLinkedGPOs) {            
    $result = [Regex]::Match($LinkedGPO,$GUIDRegex);            
    if($result.Success) {            
        $GPOGuid = $result.Value.TrimStart("{").TrimEnd("}")     
        $GPO = Get-GPO -Guid $GPOGuid -ErrorAction SilentlyContinue
        If ($LinkedGPOs.displayname -notcontains $GPO.DisplayName){
            $LinkedGPOs += $GPO             }
    }                        
}
}

$unlinkedGPOs | ForEach {
    If($_.DisplayName -notmatch "SA_"){
        $PERMS = Get-GPPermission -Name $_.DisplayName -All
        If(($PERMS.trustee | where Domain -eq HOME | select Name) -contains '_OUA_ITWT'){
            Write-Output -Name $_.DisplayName
            Set-GPPermission -Name $_.DisplayName -TargetName "_OUA_ITWT" -TargetType Group -PermissionLevel GPOEditDeleteModifySecurity -confirm:$false
            #Set-GPPermission -Name $_.DisplayName -TargetName "agpm_sa" -TargetType User -PermissionLevel GPOEditDeleteModifySecurity -confirm:$false -whatif
            }
        }
   }
$linkedGPOs | ForEach {
    If($_.DisplayName -notmatch "SA_"){
        $PERMS = Get-GPPermission -Name $_.DisplayName -All
        If(($PERMS.trustee | where Domain -eq HOME | select Name) -contains '_OUA_ITWT'){
            Write-Output -Name $_.DisplayName
            Set-GPPermission -Name $_.DisplayName -TargetName "_OUA_ITWT" -TargetType Group -PermissionLevel GPOEditDeleteModifySecurity -confirm:$false -whatif
            #Set-GPPermission -Name $_.DisplayName -TargetName "agpm_sa" -TargetType User -PermissionLevel GPOEditDeleteModifySecurity -confirm:$false -whatif
            }
        }
   }
ForEach($GPO in $UnlinkedGPOS) {Export-CSV -InputObject $GPO -path C:\Working\UnlinkedGPOs.csv -Append }


