Import-Module ActiveDirectory

$firstName = Read-Host -Prompt 'Input the first name'
$lastName = Read-Host -Prompt 'Input the last name'
$userName = Read-Host -Prompt 'Input the username'
$password = Read-Host -Prompt 'Input the password' -AsSecureString

$userDN = "CN=$userName,OU=Users,DC=YourDomain,DC=com"

$templateUser = Get-ADUser -Identity "AlejandroAA" -Properties *

New-ADUser -SamAccountName $userName -UserPrincipalName "$userName@Evaluableiso.local" -Name "$firstName $lastName" -GivenName $firstName -Surname $lastName -Description $templateUser.Description -Enabled $true -Path $userDN -AccountPassword $password -PassThru

Get-ADUser -Identity "AlejandroAA" -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Add-ADGroupMember -Members $userName