# Connect LON-Core1
Enter-PSSession lon-core1

# Get FW rules for File and Printer Sharing
Get-NetFirewallRule -DisplayGroup "File and Printer Sharing" | Format-Table

# Activate Rules for File and Printer Sharing
Get-NetFirewallRule -DisplayGroup "File and Printer Sharing" | `
    Enable-NetFirewallRule