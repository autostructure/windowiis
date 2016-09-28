<#
.SYNOPSIS
   This script is run after the Windows IIS features are installed
   on a newly provisioned IIS server.

.DESCRIPTION
   This script performs 4 functions.
   1. Create the "IIS Administrator” group.
   2. Enable Web Management via the Windows Registry.
   3. Set the Web Management service to start automatically and start it.
   4. Check the existance of drive “E:\”

.PARAMETER <paramName>
   None.

.EXAMPLE
   Executed using an "exec" command in Puppet.

. AUTHOR
   Jay Weaver
#>

 # Windows IIS Administrator existance check to determine running
 $regkey = "HKLM:\SOFTWARE\Microsoft\WebManagement\Server"
 $name = "EnableRemoteManagement"

 #--
 #-- Script to check existance of a volumne drive E
 #--
 $path = ""
 $dataDisk = Get-Volume | Where {$_.DriveLetter -eq "E"}
 if($dataDisk)
 {
   $path = "$($dataDisk.DriveLetter):\InstallLog\IIS85_Install.log"
   $pathExists = Test-Path $path
   if($pathExists -eq "True")
   {
       Remove-Item -Path $path
   }
   else
   {
      New-Item -ItemType Directory -Name InstallLog -Path "$($dataDisk.DriveLetter):\" -Confirm:$false | Out-Null
   }
 }
 else
 {
   $path = 'c:\IIS85_Install.log'
   $noData = "Unable to locate E:\ drive volume." | Out-File $path -NoClobber -Append
 }
 
 #--
 #-- IIS Administrato group and Web Management service
 #--
  
 try
 {
  #-- Create local Windows Group
  net localgroup "IIS Administrator" /Add /comment:"IIS Admin for Delegation" | Out-Null
  #-- Remote access to the Web Management Service
  Set-ItemProperty -Path $regkey -Name $name -Value 1
  Set-Service -name WMSVC -StartupType Automatic
  Start-service WMSVC
  
  $success = "Roles and Features successfully installed on $env:computername..."
  $success | Out-File $path -NoClobber -Append
 }
 catch
 {
    Write-Host $_
    $_ | Out-File $path -NoClobber -Append
 }

