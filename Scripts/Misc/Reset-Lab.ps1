# Query Virtual Machines
$vmArr = Get-VM -Name "20743B*"

# Reset VM and update Memory Cfg
foreach ($vm in $vmArr) {
    Get-VMSnapshot -VM $vm -Name "StartingImage" | Restore-VMSnapshot -Confirm:$false
    Set-VMMemory -VM $vm -StartupBytes 4096MB
}