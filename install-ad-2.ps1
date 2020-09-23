Set-DnsServerForwarder -IPAddress 1.1.1.1, 1.0.0.1;

Set-DnsServerForwarder -UseRootHint $false;

Set-ADDefaultDomainPasswordPolicy -Identity certlab.local -ComplexityEnabled $false -MinPasswordLength 4;

gpupdate /force;

start-sleep -Seconds 10;

New-ADOrganizationalUnit -Name "Domain Admins" -Path "DC=certlab,DC=local" -ProtectedFromAccidentalDeletion $False;

New-ADUser -Name "jovanadmin" -AccountPassword (ConvertTo-SecureString "P@$$W0rd" -AsPlainText -Force) -GivenName "JovanAdmin" -Path "OU=Domain Admins,DC=certlab,DC=local" -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

$AdminGroups = @("Domain Admins", "Enterprise Admins", "Administrators")

foreach ($AdminGroup in $AdminGroups) {
    Add-ADGroupMember -Identity $AdminGroup -Members jovanadmin
    }
