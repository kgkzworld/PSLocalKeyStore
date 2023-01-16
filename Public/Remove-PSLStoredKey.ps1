#region Remove-PSLStoredKey (Function)
function Remove-PSLStoredKey {
    <#
    .SYNOPSIS
        Remove-PSLStoredKey is a function that will remove a stored secret for a specified key name.

    .DESCRIPTION
        Remove-PSLStoredKey is a function that will remove a stored secret for a specified key name.

    .PARAMETER KeyName
        Description:  The Name of the Key to remove the secret for
        Notes: This is a required parameter
        Alias: Name
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes: This is a switch parameter
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Remove-PSLStoredKey -KeyName 'MyKey'
        Description: Removes the secret for the key 'MyKey'
        Notes: Process returns True if the key was removed successfully, False if the key was not found
        Output:

    .EXAMPLE
        Command: Remove-PSLStoredKey -Help
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
    [Alias('RemovePSL', 'DelPSL')]
    #region Parameters
        Param (
            [Alias('Name')]
            [string]$KeyName,

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

            #region Check Manadatory Parameters
                If ( -Not $KeyName ) {
                    Write-Error -Message "The parameter 'KeyName' is mandatory.  Please provide a value for this parameter and try again."
                    $fbegin = $false
                    $fprocess = $false
                    Return
                }
            #endregion Check Manadatory Parameters
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
                If ( $KeyName ) {
					$FoundKey = Get-ItemPropertyValue -Path $KeyPath `
						-Name $KeyName -ErrorAction SilentlyContinue

					If ( $FoundKey ) {
						Try {
							Remove-ItemProperty -Path $KeyPath -Name $KeyName -Force -ErrorAction Stop
							$MyReturn = $True
						} Catch {
							Write-Error $_
							$MyReturn = $False
						}
					}
				}
            #endregion Main
        }
    #endregion process

    #region end
        end {
            Write-Verbose 'Processing End block'

            #region Output
                Return $MyReturn
            #endregion Output
        }
    #endregion end
}
#endregion Remove-PSLStoredKey (Function)