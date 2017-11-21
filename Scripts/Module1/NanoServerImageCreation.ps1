﻿# Create a new folder
New-Item -Path C:\Nano -ItemType Directory

# Query .ps* Files in D:\NanoServer\NanoServerImageGenerator\
$fileArr = Get-ChildItem -Path D:\NanoServer\NanoServerImageGenerator -Filter "*.ps*"
$fileArr

# Copy files that match .ps* to C:\Nano
$fileArr | ForEach-Object { 
    Copy-Item -Path $_.FullName -Destination C:\Nano
} 

# Import NanoServer Module from C:\Nano\...
Import-Module C:\Nano\NanoServerImageGenerator.psm1

# Create new Nano Server Image for LON-SVR1
$nanoServerName = "Nano-Svr1"
$targetPath = Join-Path -Path C:\Nano -ChildPath ($nanoServerName + ".vhdx")
New-NanoServerImage -Edition Standard -MediaPath D:\ -BasePath C:\Nano `
    -TargetPath $targetPath -DeploymentType Guest `
$intArr = 1..10

foreach ($int in $intArr) {
    $nanoServerName = "Nano-Svr$int"
    $targetPath = Join-Path -Path C:\Nano -ChildPath ($nanoServerName + ".vhdx")
    $targetPath
    <#
    New-NanoServerImage -Edition Standard -MediaPath D:\ -BasePath C:\Nano `
        -TargetPath $targetPath -DeploymentType Guest `