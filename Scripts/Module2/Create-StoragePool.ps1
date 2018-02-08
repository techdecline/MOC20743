# Create Storage Pool
New-StoragePool -FriendlyName "StoragePool1" -StorageSubSystemName (Get-StorageSubSystem).Name `
    -PhysicalDisks (Get-PhysicalDisk | Where-Object {$_.CanPool -eq $true})

# Create Virtual Disk on newly created storage pool
New-VirtualDisk -StoragePoolFriendlyName "StoragePool1" -ResiliencySettingName Mirror `
    -FriendlyName "Mirror" -Size 10GB -NumberOfDataCopies 2 -ProvisioningType Thin

# Create Volume on virtual disk
$disk = Get-Disk | Where-Object {$_.OperationalStatus -eq "Offline"}

$disk | set-disk -IsOffline $false$disk | Initialize-Disk -PartitionStyle GPT$disk | New-Partition -UseMaximumSize -DriveLetter F |     Format-Volume -FileSystem ReFS -NewFileSystemLabel "Mirror"