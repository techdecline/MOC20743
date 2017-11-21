function Resolve-DNSScopeRecord {
    param (
        [String]$ResourceRecord,
        [String]$ZoneName
    )

    $zoneScopeArr = Get-DnsServerZoneScope -ZoneName $ZoneName
    $returnArr = @()
    foreach ($zoneScope in $zoneScopeArr)
    {
        $zoneScopeName = $zoneScope.ZoneScope
        $resourceRecordObj = Get-DnsServerResourceRecord -Name $ResourceRecord `
            -ZoneName $ZoneName `
            -ZoneScope $zoneScopeName
        if ($resourceRecordObj) {
            $returnObj = New-Object -TypeName PSCustomObject

            Add-Member -InputObject $returnObj -MemberType NoteProperty -Name ZoneScope `
                -Value $zoneScopeName
            Add-Member -InputObject $returnObj -MemberType NoteProperty -Name HostName `
                -Value $resourceRecordObj.HostName
            Add-Member -InputObject $returnObj -MemberType NoteProperty -Name IpAddress `
                -Value $resourceRecordObj.RecordData.IPv4Address.IPAddressToString
            $returnArr += $returnObj
        } 
    }

    return $returnArr
}

function Test-DnsScope {
    $zoneArr = Get-DnsServerZone | Where-Object {$_.isReverseLookupZone -eq $false}

    foreach ($zone in $zoneArr) {
        if ((Get-DnsServerZoneScope -ZoneName $zone.ZoneName -ErrorAction SilentlyContinue).Count -gt 1 ) {
            $zone.ZoneName
        }
    }
}

Get-DnsServerZoneScope -ZoneName adatum.com | ForEach-Object {
    Get-DnsServerResourceRecord -Name www -ZoneName adatum.com -ZoneScope $_.zonescope
}