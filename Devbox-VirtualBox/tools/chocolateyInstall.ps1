﻿$packageName = "Devbox-VirtualBox" # filename-safe value
$installerType = "exe"
$url = "http://download.virtualbox.org/virtualbox/4.3.20/VirtualBox-4.3.20-96997-Win.exe"
$url64 = $url
$silentArgs = "-silent"
$validExitCodes = @(0)

# Debug recommend
# Set-StrictMode –version Latest

# Exit if software is already installed,
# except if forced with `cinst -force` command line option
#
Stop-OnAppIsInstalled -pkg $packageName -match "Oracle VM VirtualBox" -ignore "Oracle VM VirtualBox Guest Additions" -force $force

try {

    # Install package
    #
    Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

    # VirtualBox will set VBOX_INSTALL_PATH environment variable. Sometimes,
    # it can contain multiple paths, as a leftover of old installations
    # and updates. These multiple paths are properly seperated with
    # semicolon, so it's safe simply all to append to path.
    #
    # Source: https://github.com/mitchellh/vagrant/issues/885
    #
    Update-SessionEnvironment
    $varValue = $Env:VBOX_INSTALL_PATH
    Write-Host "Environment variable is set: VBOX_INSTALL_PATH = $varValue"

    Install-ChocolateyPath $varValue
    Write-Host "And also appended to the users PATH variable."

    # Success
    Write-ChocolateySuccess "$packageName"
} catch {
    Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
    throw
}
