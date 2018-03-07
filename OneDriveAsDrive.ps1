$OneDriveBusAccounts = Get-ChildItem -Path HKCU:\Software\Microsoft\OneDrive\Accounts | where Name -match "Business" 

ForEach ($Account in $OneDriveBusAccounts) {

    If((Get-ITemProperty $Account.PSPath | select ConfiguredTenantID).ConfiguredTenantID -eq  "3c176536-afe6-43f5-b966-36feabbe3c1a"){

    $OneDrive4BUserFolder = Get-ITemProperty $Account.PSPath | Select -ExpandProperty "UserFolder" -ErrorAction Ignore 

    }

}

$netuseU = 'net use U: "\\localhost\'+$OneDrive4BUserFolder.replace(":","$")+'"'

New-ItemProperty -Name OneDrive2U -Path HKCU:\software\microsoft\Windows\CurrentVersion\Run -Value $netuseU

$MountPointPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##localhost#" + ($OneDrive4BUserFolder.replace(":","$")).replace("\","#")

New-ItemProperty -Name _LabelFromReg -path $MountPointPath -Value "OneDrive - The University of Kansas"

$iconfile = $env:LocalAppdata+"\onedrive.ico"

Invoke-Wjkabrequest -Uri http://www.icons101.com/icon_ico/id_78105/OneDrive.ico -OutFile $iconfile