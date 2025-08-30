Import-Module ActiveDirectory

New-ADOrganizationalUnit -DisplayName “Departamentos” –Name “Departamentos” -Path “DC=ISO,DC=.COM”
New-ADOrganizationalUnit -DisplayName “Administracion” –Name “Administracion” -Path “OU=Departamentos,DC=ISO,DC=COM”
New-ADOrganizationalUnit -DisplayName “Tecnico” –Name “Tecnico” -Path “OU=Departamentos,DC=ISO,DC=COM”
New-ADOrganizationalUnit -DisplayName “Secretaria” –Name “Secretaria” -Path “OU=Administracion,OU=Departamentos,DC=ISO,DC=COM”
New-ADOrganizationalUnit -DisplayName “Soporte” –Name “Soporte” -Path “OU=Administracion,OU=Departamentos,DC=ISO,DC=COM”
New-ADOrganizationalUnit -DisplayName “Informatica” –Name “Informatica” -Path “OU=Tecnico,OU=Departamentos,DC=ISO,DC=COM”


New-AdGroup -Name “Secretaria” -SamAccountName Secretaria -GroupCategory Security -GroupScope Global -DisplayName “Secretaria” -Path “OU=Secretaria,OU=Administracion,UO=Departamentos,DC=ISO,DC=COM” -Description “Grupo de Secretariaria”
New-AdGroup -Name “Soporte” -SamAccountName Soporte -GroupCategory Security -GroupScope Global -DisplayName “Soporte” -Path “OU=Secretaria,OU=Administracion,UO=Departamentos,DC=ISO,DC=COM” -Description “Grupo de Soporte”
New-AdGroup -Name “Informatica” -SamAccountName Informatica -GroupCategory Security -GroupScope Global -DisplayName “Informatica” -Path “OU=Informatica,OU=Tecnico,UO=Departamentos,DC=ISO,DC=COM” -Description “Grupo de Informatica”


New-ADUser  -DisplayName “Nicolas Lopez Mariel” -Name “NILOMA” -SamAccountName “Nicolas” -UserPrincipal “Nicolas” -Enabled:$True -Path “OU=Secretaria,OU=Administracion,OU=Departamentos,DC=ISO,DC=COM” -AccountPassword (ConverTo-SecureString -string “Cursos1234” -AsPlainText  -Force) -ChangePasswordAtLogon:$True -ScriptPath “ini.vbs”
New-ADUser  -DisplayName “Gabriel Lucendo Mendoza” -Name “GALUME” -SamAccountName “Gabriel” -UserPrincipal “Gabriel” -Enabled:$True -Path “OU=Soporte,OU=Administracion,OU=Departamentos,DC=ISO,DC=COM” -AccountPassword (ConverTo-SecureString -string “Cursos1234” -AsPlainText  -Force) -ChangePasswordAtLogon:$True -ScriptPath “ini.vbs”
New-ADUser  -DisplayName “Maria Pedralba Merino” -Name “MAPEME” -SamAccountName “Maria” -UserPrincipal “Maria” -Enabled:$True -Path “OU=Informatica,OU=Tecnico,OU=Departamentos,DC=ISO,DC=COM” -AccountPassword (ConverTo-SecureString -string “Cursos1234” -AsPlainText  -Force) -ChangePasswordAtLogon:$True -ScriptPath “ini.vbs”

Add-ADGroupMember “Secretaria” NILOMA
Add-ADGroupMember “Soporte”  GALUME
Add-ADGroupMember “Informatica” MAPEME


cd ..

MKDIR COMPARTIR

cd COMPARTIR

MKDIR SOPORTE
MKDIR INFORMATICA
MKDIR SECRETARIA

New-SmbShare -Name Informatica -Path “C:\COMPARTIR\INFORMATICA” -FullAccess “Informatica”
New-SmbShare -Name Soporte -Path “C:\COMPARTIR\SOPORTE” -FullAccess “Soporte”
New-SmbShare -Name Secretaria -Path “C:\COMPARTIR\SECRETARIA” -FullAccess “Secretaria”