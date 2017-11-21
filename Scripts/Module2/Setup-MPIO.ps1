# Enable secondary network connections
Get-NetAdapter -Name "Ethernet 2" | Enable-NetAdapter

# Enable secondary network adapter on LON-DC1
Invoke-Command -ScriptBlock { Get-NetAdapter -Name "Ethernet 2" | Enable-NetAdapter } `
    -ComputerName LON-DC1

# Install MPIO on LON-DC1
Install-WindowsFeature -ComputerName LON-DC1 -Name Multipath-IO `
    -Restart -IncludeAllSubFeature -IncludeManagementTools