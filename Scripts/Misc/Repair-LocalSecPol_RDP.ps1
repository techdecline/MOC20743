secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("SeDenyRemoteInteractiveLogonRight = *S-1-5-113,*S-1-5-32-546", "SeDenyRemoteInteractiveLogonRight = *S-1-5-32-546") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg
rm -force c:\secpol.cfg -confirm:$false