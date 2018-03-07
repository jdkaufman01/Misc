$url = "https://download.microsoft.com/download/8/9/9/899EEF2C-55ED-4C66-9613-EE808FCF861C/EwsManagedApi.msi"
$output = "$env:TeMP\ewsmanagedapi.msi" 

Function Start-DownloadFile{

Param(
    $url,
    $output
)

(New-Object System.Net.WebClient).DownloadFile($url, $output)

$output

}

Function Start-MSIInstall {
param(
$filepath
)


Invoke-Command -ScriptBlock { msiexec /i $filepath /qb }

}

$filepath = Start-DownloadFile -url $url -output $output 

Start-MSIInstall -filepath $filepath 