# Module 1 Example Code - Create Nano Server with ODJ File
#################################################

# 0. Variables
##############

$dcName = "CM-DC1"
$nanoName = "CM-Nano1"
$basePath = "C:\NanoServer"
$mediaPath = "J:\"
$securePassword = ConvertTo-SecureString -AsPlainText "Pa55w.rd" -Force
$switchName = "Private Network"

# 1. Generate Blob File
#######################

Invoke-Command -ComputerName $dcName -ArgumentList $nanoName -ScriptBlock {
    param ($NanoName)
    djoin.exe /provision /domain decline.lab /machine $NanoName /savefile "$env:windir\Temp\$NanoName.blob"
}

# 2. Load Nano Server Module
############################

Import-Module "$basePath\NanoServerImageGenerator\NanoServerImageGenerator.psm1"

# 3. Create Nano Server Image
#############################

New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $mediaPath -BasePath $basePath `
    -TargetPath (Join-Path -Path $basePath -ChildPath "$nanoName.vhdx") -Storage -Compute `
    -DomainBlobPath "\\$dcName\c$\Windows\Temp\$nanoName.blob" -AdministratorPassword $securePassword

# 4. Create Nano VM (requires Nested Virtualization)
####################################################

New-VM -Name $nanoName -MemoryStartupBytes 2GB -VHDPath (Join-Path -Path $basePath -ChildPath "$nanoName.vhdx") -Generation 2 `    -SwitchName $switchName