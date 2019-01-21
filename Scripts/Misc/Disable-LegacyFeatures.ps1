# Remove unwanted Features

# PowerShell 2.0
Get-WindowsFeature PowerShell-V2 | Remove-WindowsFeature -Remove

# SMB 1.0
Get-WindowsFeature FS-SMB1 | Remove-WindowsFeature -Remove -Restart