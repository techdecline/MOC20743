param (
    [Parameter(Mandatory,ValueFromPipeline)]
    [String]$VMName,

    [Parameter(Mandatory)]
    [ValidateScript({Test-Path $_})]
    [String]$BasePath,

    [Parameter(Mandatory=$false)]
    [String]$MasterImage = "C:\Program Files\Microsoft Learning\Base\Base17C-WS16-1607.vhd",

    [Parameter(Mandatory=$false)]
    [Switch]$Differencing,

    [Parameter(Mandatory=$false)]
    [ValidateScript({Test-Path $_})]
    [ValidatePattern(".xml")]
    [String]$UnattendFilePath
)

#region Create Folder
$newPath = Join-Path $BasePath -ChildPath $VMName
$newfolderObj = New-Item -Path $newPath -ItemType Directory
#endregion

#region Create Disk
$extension = $MasterImage -replace "^.*\.",""
$newVhdPath = Join-Path -Path $newfolderObj.FullName -ChildPath "$VMName.$extension"

if ($Differencing) {
    $newVhdObj = New-VHD -Path $newVhdPath -ParentPath $MasterImage
}
else {
    $newVhdObj = Copy-Item -Path $MasterImage -Destination $newVhdPath -PassThru
}
#endregion

#region Create VM
$vmParam = @{
    Name = $VMName
    MemoryStartupBytes = 2GB
    SwitchName = "Private Network"
    VHDPath = $newVhdPath
}

if ($extension -eq "vhd") {
    $vmParam.Add("Generation",1)
}
else {
    $vmParam.Add("Generation",2)    
}
New-VM @vmParam
#endregion

#region Unattend
if ($UnattendFilePath) {
    Mount-VHD $newVhdPath
    $driveLetter = (Get-DiskImage $newVhdPath | 
        Get-Disk | Get-Partition | Where-Object {$_.Size -gt 1GB}).DriveLetter
    Copy-Item -Path $UnattendFilePath -Destination ("$driveLetter" + ":\Windows\System32\sysprep\unattend.xml")
    Dismount-DiskImage -ImagePath $newVhdPath
}
#endregion