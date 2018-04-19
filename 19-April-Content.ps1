#enhance the capabilities of PS6
Install-Module WindowsPSModulePath -Force

Add-WindowsPSModulePath
#_________________________
# add to profile for continued ease of use
# create profile if it does not yet exist
$exists = Test-Path -Path $Profile.CurrentUserAllHosts
if (!$exists){
    New-Item -Path $Profile.CurrentUserAllHosts -ItemType File -Force | Out-Null    
}
# add code to profile
$code = 
@'

Add-WindowsPSModulePath
'@
$code | Add-Content -Path $Profile.CurrentUserAllHosts -Encoding Default
#_________________________
#--------------------------------------------------------------------------------
#SHiPS capabilities demo1
#https://github.com/PowerShell/CimPSDrive

Get-Module -ListAvailable #take a look at what is available

#install the CimPSDrive module - SHiPS will also be added
Install-Module -Name CimPSDrive -Scope CurrentUser

#import CimPSDrive module
Import-Module -Name CimPSDrive -Verbose

Get-PSDrive #see what drives are current available

#create a drive associated with the CIM space
New-PSDrive -Name CIM -PSProvider SHiPS -Root CIMPSDrive#CMRoot

cd cim: #start navigating

#remove the drive
cd C:\
Remove-PSDrive -Name CimPSDrive
#--------------------------------------------------------------------------------
#SHiPS capabilities demo2
#https://github.com/PowerShell/AzurePSDrive

#install PowerShellGet to be able to get azure cmdlets
Install-Module PowerShellGet -Force

# Install the Azure Resource Manager modules from the PowerShell Gallery
Install-Module -Name AzureRM -AllowClobber #can also be used to upgrade version

#import Azure module
Import-Module -Name AzureRM

# Authenticate to your Azure account
Login-AzureRMAccount

#install AzurePSDrive module
Install-Module -Name AzurePSDrive

# Create a drive for AzureRM
$driveName = 'Az'
Import-Module AzurePSDrive
New-PSDrive -Name $driveName -PSProvider SHiPS -Root AzurePSDrive#Azure

#start navigating
cd $driveName":"

#you can take actions via the pipeline (even search)
dir | Stop-AzureRmWebApp

# Mount to Azure file share so that you can add/delete/modify files and directories
net use z: \\myacc.file.core.windows.net\share1  /u:AZURE\myacc <AccountKey>

#remove the drive
cd C:\
Remove-PSDrive -Name $driveName
#--------------------------------------------------------------------------------
Find-Module -Tag SHIPS
#--------------------------------------------------------------------------------