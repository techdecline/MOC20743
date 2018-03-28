 $str = "AxInstSV bthserv CDPUserSvc PimIndexMaintenanceSvc dmwappushservice MapsBroker lfsvc SharedAccess lltdsvc wlidsvc NgcSvc NgcCtnrSvc NcbService PhoneSvc PcaSvc QWAVE RmSvc SensorDataService SensrSvc SensorService ShellHWDetection ScDeviceEnum SSDPSRV WiaRpc OneSyncSvc TabletInputService upnphost UserDataSvc UnistoreSvc WalletService Audiosrv AudioEndpointBuilder FrameServer stisvc wisvc icssvc WpnService WpnUserService XblAuthManager XblGameSave"
$strArr = $str -split " "

Get-Service | Select-Object Name,StartType |Export-Csv "$env:TEMP\servicesDefault.csv" -NoTypeInformation -Delimiter "," 

foreach ($svc in $strArr) {
    try {
        Get-Service $svc | Set-Service -StartupType Disabled -ErrorAction Stop -ErrorVariable svcCfgError
        Stop-Service $svc
    }
    catch {
        $svcCfgError
    }
} 
