# Vars
. ".vscode\Global.ps1"

# Install-Module -Name "IntuneWin32App" -force
Get-installedModule -Name IntuneWin32App
# Retrieve auth token required for accessing Microsoft Graph
# Delegated authentication is currently supported only, app-based authentication is on the todo-list
Connect-MSIntuneGraph -TenantID "interstellar.nl" -Verbose

    # TODO Fill in the variables
    $Publisher = "INTERSTELLAR"
    $IntuneWinFile = "$Desktop\$Application\$Application.intunewin"
    $AppIconFile = "C:\Stuff\test-icon.png"
    $Appversion = "1.00"

    # TODO Create custom display name like 'Name' and 'Version'
    $DisplayName = "TEST Application name"
    Write-Output -InputObject "Constructed display name for Win32 app: $($DisplayName)"

    # TODO Create requirement rule for all platforms and Windows 10 20H2
    $RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "All" -MinimumSupportedWindowsRelease "W11_22H2"

    # TODO Create PowerShell script detection rule
    $DetectionScriptFile = "C:\Stuff\CustomDetection.ps1"
    $DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile $DetectionScriptFile -EnforceSignatureCheck $false -RunAs32Bit $false

    # Convert image file to icon
    $Icon = New-IntuneWin32AppIcon -FilePath $AppIconFile
    
    # Add new EXE Win32 app
    $InstallCommandLine = '.\Deploy-Application.exe -DeploymentType "Install" -DeployMode "Silent"'
    $UninstallCommandLine = '.\Deploy-Application.exe -DeploymentType "Uninstall" -DeployMode "Silent"'
    # TODO Add app description
    Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description "TEST Application name" -AppVersion $Appversion -Publisher $Publisher -InstallExperience "system" -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Icon $Icon -Verbose

    #Write-Output -InputObject "Starting to create Win32 app in Intune"
    #$Win32App = Add-IntuneWin32App @Win32AppArguments

    Write-Output -InputObject "Successfully created new Win32 app with name: $($Win32App.displayName)"