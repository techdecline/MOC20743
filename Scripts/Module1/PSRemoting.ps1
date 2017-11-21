# Update Trusted Hosts to manage LON-CORE1
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "172.16.0.160" `
    -Confirm:$false -Force

# Verify TrustedHosts List
Get-Item WSMan:\localhost\Client\TrustedHosts

# Verify Remote Connectivity
Test-WSMan -ComputerName 172.16.0.160

# Open and enter PS Session on 172.16.0.160
$targetHost = "172.16.0.160"
$cred = Get-Credential "$targetHost\Administrator"
Enter-PSSession 172.16.0.160 -Credential $cred

# Rename Computer, Restart, Add Domain
Rename-Computer -NewName LON-Core1
Restart-Computer -Force
Add-Computer -DomainName adatum.com -Server lon-dc1.adatum.com `
    -Credential adatum\administrator