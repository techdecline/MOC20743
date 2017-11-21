# Initialize and format all iSCSI Disks
$diskArr = Get-PhysicalDisk | Where-Object {$_.BusType -eq "iSCSI"}
$i = 1

foreach ($disk in $diskArr) {
    $disk | get-disk | set-disk -IsOffline $false
    $disk | Get-Disk | Initialize-Disk -PartitionStyle GPT
    $disk | Get-Disk | New-Partition -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -NewFileSystemLabel "Disk$i" 
    $i = $i + 1
}

# Set iSCSI Disks online in LON-SVR3
Invoke-Command -ComputerName LON-SVR3 -ScriptBlock {
    $diskArr = Get-PhysicalDisk | Where-Object {$_.BusType -eq "iSCSI"}

    foreach ($disk in $diskArr) {
        $disk | get-disk | set-disk -IsOffline $false
    }
}

# Install Failover-Clusterung, File Server Role on LON-SVR2,LON-SVR3
Install-WindowsFeature -ComputerName "LON-SVR3" -Name "Failover-Clustering","FS-FileServer" `
    -IncludeManagementTools -Restart

Install-WindowsFeature -Name "Failover-Clustering","FS-FileServer" `
    -IncludeManagementTools -Restart

# Validate and Create Cluster
Test-Cluster -Node "LON-SVR2","LON-SVR3"
New-Cluster -Name Cluster1 -Node "LON-SVR2","LON-SVR3" -StaticAddress "172.16.0.125"va
