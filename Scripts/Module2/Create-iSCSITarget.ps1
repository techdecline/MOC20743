# Install iSCSI Target Server
Install-WindowsFeature FS-iSCSITarget-Server -IncludeAllSubFeature -IncludeManagementTools -Restart

# Create iSCSI Target
New-IscsiServerTarget -TargetName "LON-DC1" `
    -InitiatorIds "IPAddress:172.16.0.10","IPAddress:10.10.0.10" -OutVariable targetObj

# Create iSCSI Virtual Disks

$arr = 1..5

foreach ($i in $arr) {
    $iSCSIVirtualDiskPath = Join-Path -Path C:\ -ChildPath ("iSCSIDisk$i" + ".vhdx")
    
    if ( -not (Test-Path $iSCSIVirtualDiskPath) ) {
        New-IscsiVirtualDisk -Path $iSCSIVirtualDiskPath -SizeBytes 5GB
        Add-IscsiVirtualDiskTargetMapping -TargetName $targetObj.TargetName -Path $iSCSIVirtualDiskPath
    }
}