# Add replacement disk
Get-StoragePool -FriendlyName "StoragePool1" `
    | Add-PhysicalDisk -PhysicalDisks ( Get-PhysicalDisk -CanPool $true )

# Tidy up Storage Pool
Remove-PhysicalDisk -PhysicalDisks (
    Get-PhysicalDisk -StoragePool (Get-StoragePool -FriendlyName "StoragePool1") `
    | Where-Object { $_.OperationalStatus -ne "OK" } 
) -StoragePoolFriendlyName "StoragePool1" -Confirm:$false 