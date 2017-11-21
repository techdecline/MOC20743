# Read Out current SKU
DISM.exe /online /Get-CurrentEdition

# Change SKU after installation (only upgrade)
DISM.exe /online /Set-Edition:ServerDatacenter/ProductKey:12345-67890-12345-67890-12345 /AcceptEula