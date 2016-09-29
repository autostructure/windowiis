# Class: windows_webserver
# ===========================
#
# This class performs two funtions for the provisioning
# of a Windows IIS web server.
#   1.  Activate the IIS Windows Features executing the "windowsfeature" module.
#   2.  Run a PowerShell scrip to verify that file system
#       disk is available to install a default IIS web site on.
#
# Parameters
# ----------
#  N/A
#
# Variables
# ----------
#  N/A
#
# Examples
# --------
#
# @example
#   In site/role/manifests/params.pp add line, include windows_webserver
#   In the PE console under classes add, role:windows_webserver
#
# Authors
# -------
#
# Jay Weaver jayweaver@fs.fed.us
#
# Copyright
# ---------
#
# Copyright 2016 Jay Weaver, US Forest Service.
#
class windows_webserver {



windowsfeature {
  'NET-Framework-45-ASPNET',
  'Web-Server',
  'Web-Default-Doc',
  'Web-Dir-Browsing',
  'Web-Http-Errors',
  'Web-Static-Content',
  'Web-Http-Logging',
  'Web-Custom-Logging',
  'Web-Log-Libraries',
  'Web-Filtering',
  'Web-Basic-Auth',
  'Web-Url-Auth',
  'Web-Windows-Auth',
  'Web-Net-Ext45',
  'Web-ASP',
  'Web-ASP-Net45',
  'Web-ISAPI-Ext',
  'Web-ISAPI-Filter',
  'Web-Mgmt-Console',
  'Web-Mgmt-Service']
   timeout => 1800,
   ensure => present,
 } ->

 exec { 'check_drive':
  command   => file('windows_webserver/CheckDrive.ps1'),
  onlyif    => ('if ([ADSI]::Exists("WinNT://localhost/IIS Administrator")) { exit 1 } else { exit 0 }'),
  provider  => powershell,
 }

}
