$HOMEdomainGPOs = Get-GPO -all 
$NoPerms = @()
$ITWTPermys = Import-CSV -Path C:\working\itwtperms.csv

ForEach ($GPO in $ITWTPermys) {
$ITWTPerms = $Null
$ITWTPerms = Get-GPPermission -Guid $GPO.id -TargetName "_OUA_ITWT" -TargetType "Group" -ErrorAction SilentlyContinue

If($ITWTPerms -eq $Null){
$NOperms += $GPO
Set-GPPermission -Guid $GPO.ID -TargetName "_OUA_ITWT" -TargetType Group -PermissionLevel GpoEditDeleteModifySecurity -Confirm:$False -Verbose
}
}


ForEach ($GPO in $badGPOS){
$ITWTPerms = $Null
$GPExists = $null

$GPExists = Get-GPO -Guid $GPO.id 
If($GPexists -ne $Null){
$ITWTPerms = Get-GPPermission -Guid $GPO.id -TargetName "_OUA_ITWT" -TargetType "Group" -ErrorAction SilentlyContinue

If($ITWTPerms -eq $Null){
Write $GPO.DisplayName
Set-GPPermission -Guid $GPO.ID -TargetName "_OUA_ITWT" -TargetType Group -PermissionLevel GpoEditDeleteModifySecurity -Confirm:$False -Verbose
}
}
}

$badgpos = $badgpos | where displayname -notmatch "PHSX"