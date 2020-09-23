$IP_Addr = Read-Host "Enter an IP Address"
$Dname = Read-Host "Enter the name of your domain"

New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4 -PrefixLength 24 -IPAddress $IP_Addr -DefaultGateway 192.168.1.1;

Disable-NetAdapterBinding –InterfaceAlias “Ethernet” –ComponentID ms_tcpip6;

Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("1.1.1.1");

$dcfeatures = Get-WindowsFeature -Name AD-Domain-Services

function Install-AD {
	[CmdletBinding()]
	param()
	foreach($feature in $DCFeatures) {
		if (($feature).installstate -ne "Installed") {
			install-windowsfeature -name $feature -includemanagementtools
		}
	}
}

Install-AD;

Start-Sleep -Seconds 10;

<# Set the Scheduled Task for the Script Part 2 #>

$TaskAction = New-ScheduledTaskAction -Execute Powershell.exe -Argument "-file C:\users\administrator\desktop\ad-install-2.ps1"

$TimeExt = (get-date).AddMinutes(15).ToString("H:mm")

$TaskTrigger = New-ScheduledTaskTrigger -At $TimeExt -Once

Register-ScheduledTask -TaskName "Script 2 Prep" -Trigger $TaskTrigger -Action $TaskAction



Install-ADDSForest -InstallDns -DomainName $Dname;
