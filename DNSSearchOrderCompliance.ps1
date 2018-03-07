
[scriptblock]$script = {

     $NICs = Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"}

     $DNSAddresses = @()
    
     ForEach ($Nic in $Nics){

     $DNSAddresses += $NIC.DNSServerSearchOrder

     }
     
     $Compliant = $true
     
     # If the first DNS is not a proteus server or if there are not multiple DNS servers

     If ((!($DNSAddresses[0] -eq "129.237.32.1") -and !($DNSAddresses[0] -eq "129.237.133.1")) -or !($DNSAddresses.count -ge 2)){

        $Compliant = $false

        }
    # If Server is not compliant - remediate

    If ($Compliant -eq $false){

        $ProteusServers = "129.237.133.1","129.237.32.1"

        # If there are more than 1 nics, manually check the server out

        If ($Nics.count -eq 1){

            $NIC.SetDNSServerSearchOrder($ProteusServers)

            $NIC.SetDynamicDNSRegistration("true")

            $Compliant = "Remedied"

        }

     Else{

        $Compliant = "False, but more than 1 Nic - Resolve Manually"
        
        }    

      } 
 
    $result = @{

        "Name"=$env:ComputerName

        "DNSSettings" =  $DNSAddresses #-join ","

        "Compliance" = $Compliant.tostring() 

        }

    $result

      }

$computers = Get-ADComputer -Filter "*" -SearchBase "OU=ITES,DC=home,DC=ku,DC=edu" | select -expand DNShostname 

$result = @()

ForEach($server in $computers){

    Try{

        $Result += Invoke-Command -ScriptBlock $script -ComputerName $server -ErrorAction Ignore

    }
    Catch{

        write-host "Could not contact $server"

    }

}





[scriptblock]$script = {

     $NICs = Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"}

     $DNSAddresses = @()
    
     ForEach ($Nic in $Nics){

     $DNSAddresses += $NIC.DNSServerSearchOrder

     }

    $result = @{

        "Name"=$env:ComputerName

        "DNSSettings" =  $DNSAddresses #-join ","

        }

    $result
     }

$computers = Get-ADComputer -Filter "*" -SearchBase "OU=Domain Controllers,DC=home,DC=ku,DC=edu" | select -expand DNShostname 

$result = @()

ForEach($server in $computers){

    Try{

        $Result += Invoke-Command -ScriptBlock $script -ComputerName $server -ErrorAction Ignore

    }
    Catch{

        write-host "Could not contact $server"

    }

}



