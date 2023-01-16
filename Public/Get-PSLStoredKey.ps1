#region Get-PSLStoredKey (Function)
function Get-PSLStoredKey {
    <#
    .SYNOPSIS
        Get-PSLStoredKey is a function that will return a stored secret for a specified key name.

    .DESCRIPTION
        Get-PSLStoredKey is a function that will return a stored secret for a specified key name.

        Secrets are saved using the Set-PSLStoredKey function and are stored in an encypted string in the user's registry hive.

        Note:  This does not use Microsoft's Credential Store to store the secret.

    .PARAMETER KeyName
        Description:  The Name of the Key to retrieve the secret for
        Notes:  This is a required parameter
        Alias: Key
        ValidateSet:

    .PARAMETER ConvertFromJSON
        Description:  Convert the returned value from JSON to a PowerShell Object
        Notes: This is a switch parameter
        Alias: JSON
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes: This is a switch parameter
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Get-PSLStoredKey -KeyName 'MyKey'
        Description: Use this to retrieve the secret for the key 'MyKey'
        Notes: To Create a Key, use the Set-PSLStoredKey function
                '{"Name":"MyDomain\\Michael","Token":"3a48e249-49d4-469c-92fa-1f2956a7f609","Password":"Password!","Description":"Example Key"}' | `
                Set-PSLStoredKey -KeyName 'MyKey'

                Note:  The above example is a JSON string that is being piped to the Set-PSLStoredKey function.  The JSON string is then
                        converted to a Secure String and stored in the registry as an encrypted string.

                        If you don't want to pipe the JSON string to the Set-PSLStoredKey function, you can also use the following command:
                        Set-PSLStoredKey -KeyName 'MyKey' and you will be prompted to enter the JSON string in a secure manner.
        Output: {"Name":"MyDomain\\Michael","Token":"3a48e249-49d4-469c-92fa-1f2956a7f609","Password":"Password!","Description":"Example Key"}

    .EXAMPLE
        Command: Get-PSLStoredKey -KeyName 'MyKey' -ConvertFromJSON
        Description: Use this to retrieve the secret for the key 'MyKey' and convert it from JSON to a PowerShell Object
        Notes: To Create a Key, use the Set-PSLStoredKey function
                '{"Name":"MyDomain\\Michael","Token":"3a48e249-49d4-469c-92fa-1f2956a7f609","Password":"Password!","Description":"Example Key"}' | `
                Set-PSLStoredKey -KeyName 'MyKey'

                Note:  The above example is a JSON string that is being piped to the Set-PSLStoredKey function.  The JSON string is then
                        converted to a Secure String and stored in the registry as an encrypted string.

                        If you don't want to pipe the JSON string to the Set-PSLStoredKey function, you can also use the following command:
                        Set-PSLStoredKey -KeyName 'MyKey' and you will be prompted to enter the JSON string in a secure manner.
        Output: PSObject
                Name             Token                                Password  Description
                ----             -----                                --------  -----------
                MyDomain\Michael 3a48e249-49d4-469c-92fa-1f2956a7f609 Password! Example Key

	.EXAMPLE
        Command: Get-PSLStoredKey -Help
        Description: Use this to show the help system for this function
        Notes: If you have the PSWalkthrough Module installed, this will start the dynamic help menu system.  If not it will show the normal
                PowerShell help information for this function.

	.NOTES

        • [Original Author]
            o Michael Arroyo
        • [Original Build Version]
            o 1.0.0.20230114 [XX = Major (.) XX = Minor (.) XX = Patch XX = Build revision/Build date]
        • [Latest Author]
            o Michael Arroyo
        • [Latest Build Version]
            o 1.0.0.20230114 [XX = Major (.) XX = Minor (.) XX = Patch XX = Build revision/Build date]
        • [Comments]
            o
        • [PowerShell Compatibility]
            o 5.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o PSWalkthrough - PSWalkThrough is a module that will help convert the static PowerShell help into an interactive menu system.
    #>

	#region Build Notes
	<#
	~ Build Version Details "Moved from the Main Help Section.  There is a Char limit and PSHelp will not read all the information correctly":
		o 1.0.0.20230114: [Michael Arroyo] Inital build
	#>
	#endregion Build Notes

    [CmdletBinding()]
    [Alias('StoredKey','GetPSLKey')]
    #region Parameters
        Param (
            [Alias('Key')]
            [string]$KeyName,

            [Alias('JSON')]
            [switch]$ConvertFromJSON,

            [Alias('Help')]
            [Switch]$Walkthrough
        )
    #endregion Parameters

    #region begin
        begin {
            Write-Verbose 'Processing Begin block'

            #region Load begin, and process (code execution flags)
                $fbegin = $true
                $fprocess = $true
            #endregion Load begin, and process (code execution flags)

            #region WalkThrough (Dynamic Help)
                If( $Walkthrough ) {
                    If ( $($PSCmdlet.MyInvocation.InvocationName) ) {
                        $Function = $($PSCmdlet.MyInvocation.InvocationName)
                    } Else {
                        If ( $Host.Name -match 'ISE' ) {
                            $Function = $(Split-Path -Path $psISE.CurrentFile.FullPath -Leaf) -replace '((?:.[^.\r\n]*){1})$'
                        }
                    }

                    If ( Test-Path -Path Function:\Invoke-WalkThrough -ErrorAction SilentlyContinue ) {
                        If ( $Function -eq 'Invoke-WalkThrough' ) {
                            #Disable Invoke-WalkThrough looping
                            Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function -RemoveRun }
                            $fbegin = $false
                            Return
                        } Else {
                            Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function }
                            $fbegin = $false
                            Return
                        }
                    } Else {
                        Get-Help -Name $Function -Full
                        $fbegin = $false
                        Return
                    }
                }
            #endregion WalkThrough (Dynamic Help)

            #region Common Variables
                If ( $($MyInvocation.InvocationName) ) {
                    $ScriptName = $($MyInvocation.InvocationName)
                } Else {
                    $ScriptName = $(Split-Path -Path $psISE.CurrentFile.FullPath -Leaf) -replace '((?:.[^.\r\n]*){1})$'
                }
            #endregion Common Variables
        }
    #endregion begin

    #region process
        Process {
            Write-Verbose 'Processing Process block'

            #process Script Block Execution Check
                If ( -Not $fbegin ) {
                    #Clean Exit (Do not process anything further)
                    $fprocess = $false
                    Return
                }
            #Endprocess Script Block Execution Check

            #region Main
                $CurValue = [System.Management.Automation.PSSerializer]::DeSerialize((Get-ItemPropertyValue `
                    -Path "HKCU:\Software\Microsoft\Windows\PowerShell\Keys" -Name $KeyName))
            #endregion Main
        }
    #endregion process

    #region end
        end {
            Write-Verbose 'Processing End block'

            #region Output
                Switch ( $Null ) {
                    { $ConvertFromJSON } {
                        $ReturnObj = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(`
                            [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($CurValue)) | ConvertFrom-Json
                        Return $ReturnObj
                        break
                    }
                    { -Not $ConvertFromJSON } {
                        Return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(`
                            [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($CurValue))
                    }
                }
            #endregion Output
        }
    #endregion end
}
#endregion Get-PSLStoredKey (Function)