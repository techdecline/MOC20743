# Install Deduplication Feature
Get-WindowsFeature | Where-Object { 
    $_.Name -match "dedup" } | Install-WindowsFeature -IncludeManagementTools

# Start Dedup Job
Start-DedupJob -Type Optimization -Volume E: -Memory 50 
Get-DedupJob -Volume e:

while ((Get-DedupJob -Volume e:).State -eq "Running") {
    echo "I am busy"
    Start-Sleep -Seconds 5
    cls
}