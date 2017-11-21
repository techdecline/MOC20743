# Add LON-DC1 to Group Cloneable Domain Controllers
Set-ADGroup -Add:@{'Member'="CN=LON-DC1,OU=Domain Controllers,DC=Adatum,DC=com"} `
    -Identity:"CN=Cloneable Domain Controllers,CN=Users,DC=Adatum,DC=com" `
    -Server:"LON-DC1.Adatum.com"

# Generate Clone Exclusion List
Get-ADDCCloningExcludedApplicationList
Get-ADDCCloningExcludedApplicationList -GenerateXml

# Generate Clone Config File
New-ADDCCloneConfigFile -CloneComputerName LON-DC3

# Shutdown Computer
Stop-Computer -Force -Confirm:$false