# Change Firewall on LON-SVR3
Invoke-Command -ComputerName lon-svr3 -ScriptBlock {    Get-NetFirewallRule -DisplayGroup "Datei- und Druckerfreigabe" |         Enable-NetFirewallRule
}

# Connectivity Check in PowerShell

## ICMP Check
Test-Connection -ComputerName LON-SVR3
Test-NetConnection -ComputerName LON-SVR3 -Port 445

# Export ADFS certificate with private key
$password = ConvertTo-SecureString -AsPlainText "Passw0rd" -Force
Get-ChildItem Cert:\LocalMachine\My | 
    Export-PfxCertificate -FilePath \\lon-svr3\c$\adfs.pfx -Password $password

# Export LON-SVR1 certificate with private key
Invoke-Command -ComputerName lon-svr1 -scriptblock {
    $password = ConvertTo-SecureString -AsPlainText "Passw0rd" -Force
    Get-ChildItem Cert:\LocalMachine\My | 
        Export-PfxCertificate -FilePath c:\lon-svr1.pfx -Password $password
        # Using a local path because of issue with daisy-chained impersonation/delegation
}

# Copy cert to LON-SVR3
Copy-Item '\\lon-svr1\c$\lon-svr1.pfx' -Destination "\\lon-svr3\c$\lon-svr1.pfx"

# Import certificates on LON-SVR3
Invoke-Command -ComputerName LON-SVR3 -ScriptBlock {
    $password = ConvertTo-SecureString -AsPlainText "Passw0rd" -Force
    Get-ChildItem c:\ -Filter "*.pfx" | ForEach-Object {
        Import-PfxCertificate -CertStoreLocation Cert:\LocalMachine\My -FilePath $_.FullName `
            -Password $password
    }
}