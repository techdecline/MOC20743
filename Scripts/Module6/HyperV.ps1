# External Switch
New-VMSwitch -Name "Corporate Network" `
    -NetAdapterName ((Get-NetAdapter | Where-Object {$_.Status -eq "Up"}).Name)

# Private Switch
New-VMSwitch -Name "Private Network" -SwitchType Private

# Internal Switch
New-VMSwitch -Name "Internal Network" -SwitchType Internal 

# Set static IP on internal network adapter
$adapter = Get-NetAdapter -Name "*internal*"
New-NetIPAddress -InterfaceIndex $adapter.ifIndex -IPAddress 172.16.0.31 `
    -PrefixLength 16 -DefaultGateway 172.16.0.1
Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses 172.16.0.10

# Disable Host Network Adapter
Get-NetAdapter | Where-Object {$_.InterfaceDescription -match "^Intel.*"} | 
    Disable-NetAdapter -Confirm:$false
 
# Create Folders for new VM
New-Item 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST1' -ItemType Directory
New-Item 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST2' -ItemType Directory

# Create differencing disks for new VM
New-VHD -Path 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST1\LON-GUEST1.vhd' `
    -ParentPath 'D:\Program Files\Microsoft Learning\Base\Base17C-WS16-1607_DE.vhd'

New-VHD -Path 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST2\LON-GUEST2.vhd' `
    -ParentPath 'D:\Program Files\Microsoft Learning\Base\Base17C-WS16-1607_DE.vhd'

# Create virtual machine
New-VM -Name LON-GUEST1 -MemoryStartupBytes 2048MB -SwitchName "Private Network" `
    -VHDPath 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST1\LON-GUEST1.vhd' `
    -Path 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST1'

New-VM -Name LON-GUEST2 -MemoryStartupBytes 2048MB -SwitchName "Private Network" `
    -VHDPath 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST2\LON-GUEST2.vhd' `
    -Path 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST2'

# Prepare VM for first use
$vmName = "LON-GUEST2"
$unattendPath = Get-ChildItem "D:\temp" -Filter "$vmName*"

# mount newly created virtual disk
Mount-VHD -Path 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST2\LON-GUEST2.vhd' `
    -Passthru  

# set disk online
Get-Disk | Where-Object {$_.OperationalStatus -eq "Offline"} | Set-Disk -IsOffline $false

# get drive letter
$driveLetter = (Get-DiskImage 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST2\LON-GUEST2.vhd' | 
    Get-Disk | Get-Partition | Where-Object {$_.Size -gt 1GB}).DriveLetter

Copy-Item -Path $unattendPath.FullName -Destination ("$driveLetter" + ":\Windows\System32\sysprep\unattend.xml")

Dismount-DiskImage -ImagePath 'D:\Program Files\Microsoft Learning\21743\Drives\LON-GUEST2\LON-GUEST2.vhd'