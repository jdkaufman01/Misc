# The servers that we want to use
$newDNSServers = "129.237.32.1","129.237.133.1"

# Get all network adapters that already have DNS servers set
$adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DNSServerSearchOrder -ne $null}

# Set the DNS server search order for all of the previously-found adapters
$adapters | ForEach-Object {$_.SetDNSServerSearchOrder($newDNSServers)}