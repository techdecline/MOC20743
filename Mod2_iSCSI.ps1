# Module 2 Example Code - iSCSI
#################################

# 1. Install iSCSI Target Server
################################

Install-WindowsFeature -Name FS-iSCSITarget-Server -IncludeAllSubFeature -IncludeManagementTools -Restart

# 2. Create iSCSI Target
########################

$initiatorArr = "IPAddress:172.16.0.11","IPAddress:172.16.0.12"
$target = New-IscsiServerTarget -TargetName SampleTarget -InitiatorIds $initiatorArr

# 3. Create Disks and attach to target
$intArr = 1..3

foreach ($int in $intArr)
{
    New-IscsiVirtualDisk -Path "C:\iscsiDisk$int.vhdx" -SizeBytes 5GB | Add-IscsiVirtualDiskTargetMapping -TargetName $target.TargetName
}