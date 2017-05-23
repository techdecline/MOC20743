# Module 2 Example Code - Storage Spaces
########################################

# 1. Get available disks
########################

$availableDisks = Get-PhysicalDisk -CanPool $true

# 2. Take disks online
######################

$availableDisks | ForEach-Object { $_ | Get-Disk | Set-Disk -IsOffline:$false}

# 3. Create Storage Pool
########################

New-StoragePool -StorageSubSystemName (Get-StorageSubSystem).Name -FriendlyName "StoragePool" -PhysicalDisks $availableDisks

# 4. Create Virtual Disk on Storage Pool
########################################

$vDisk = New-VirtualDisk -StoragePoolFriendlyName "StoragePool" -Size 5GB -ResiliencySettingName Mirror `
    -FriendlyName RAID1 -ProvisioningType Thin

# 5. Partition and Format vDisk
###############################
$vDisk | Get-Disk | Initialize-Disk 
$vDisk | Get-Disk | New-Partition -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -NewFileSystemLabel Raid1

