#region Set-PSLStoredKey (Function)
function Set-PSLStoredKey {
    <#
    .SYNOPSIS
        Set-PSLStoredKey is a function that will retrieve a stored key from the current user's KeyStore

    .DESCRIPTION
        Set-PSLStoredKey is a function that will retrieve a stored key from the current user's KeyStore

    .PARAMETER Secret
        Description:  The secret to store in the KeyStore
        Notes:  This is a required parameter
        Alias:
        ValidateSet:

    .PARAMETER SecureSecret
        Description: The secure secret to store in the KeyStore
        Notes: This is an optional parameter and is using the SecureString type
        Alias:
        ValidateSet:

    .PARAMETER KeyName
        Description: The name of the key to store in the KeyStore
        Notes: This is a required parameter
        Alias:
        ValidateSet:

    .PARAMETER Force
        Description:  Force the key to be stored in the KeyStore and overwrite any existing key
        Notes: This is a switch parameter
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes: This is a switch parameter
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Set-PSLStoredKey -KeyName 'MyKey' -Secret 'MySecret'
        Description: Use this command to store a key in the KeyStore
        Notes: This command will store the key in the KeyStore.  Only the current user will be able to access this key.
        Output:

    .EXAMPLE
        Command: '{"Name":"MyDomain\Michael","Token":"3a48e249-49d4-469c-92fa-1f2956a7f609","Password":"Password!","Description":"Example Key"}' | `
            Set-PSLStoredKey -KeyName 'MyKey'
        Description: Pipe a JSON string to this command to store a key in the KeyStore
        Notes: This command will store the key in the KeyStore.  Only the current user will be able to access this key.
            The JSON string can be any valid JSON string.
        Output:

    .EXAMPLE
        Command: Set-PSLStoredKey -Help
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
    [Alias('')]
    #region Parameters
        Param (
            [Parameter(Position=0,
				ValueFromPipeline=$True
			)]
			[string]$Secret,

			[securestring]$SecureSecret,

			[Parameter(Position=1)]
			[string]$KeyName,

			[switch]$Force																										,

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

            #region Create Registry  Path if it does not exist
                $RegPath = @('HKCU:','Software','Microsoft','Windows','PowerShell','Keys')

                0..($RegPath.Length-1) | ForEach-Object -Process {
                    $ThisLevel = (-join(($RegPath[0..$_] -join "\"),"\"))
                    if (-not (Test-Path $ThisLevel)){
                        Write-Verbose "Creating $ThisLevel"
                        New-Item $ThisLevel -ItemType Directory | Out-Null
                    }
                }
            #endregion Create Registry  Path if it does not exist
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
				If ( -not $KeyName ){
					$Exception = @{
						Message = "-KeyName value has not been set. Please add a value and try again."
						Category = "WriteError"
					}
					Write-Error @Exception
					Return
				}

				If ($KeyName -notin (Read-PSLStoredKeyList) -or $Force) {
					Switch ( $Null ) {
						{ $(-Not $Secret) -and $(-Not $SecureSecret) } {
							$CurSecret = (Read-Host -AsSecureString -Prompt "Secret:")
							break
						}

						{ $Secret } {
							$CurSecret = $Secret | ConvertTo-SecureString -AsPlainText -Force
							break
						}

						{ $SecureSecret } {
							$CurSecret = $SecureSecret
							break
						}
					}

					$PathQuery = @{
						Path = ($RegPath -join "\")
						Name = $KeyName
						Value = ([System.Management.Automation.PSSerializer]::Serialize($CurSecret))
					}

					If ( $Force ) {
						Set-ItemProperty @PathQuery | Out-Null
					} else {
						$PathQuery.PropertyType = "String"
						New-ItemProperty @PathQuery | Out-Null
					}
				} else {
					$PathQuery = @{
						Path = ($RegPath -join "\")
						Name = $KeyName
						Value = ([System.Management.Automation.PSSerializer]::Serialize($Secret))
					}

					@("Value","PropertyType") | ForEach-Object -Process {
						$PathQuery.Remove($_)
					}

					$Exception = @{
						Message = (-join("A Secret with the name ",$KeyName," already exists. Choose another name or use the -Force flag to overwrite."))
						Category = "WriteError"

					}
					Write-Error @Exception
				}
            #endregion Main
        }
    #endregion process

    #region end
        end {
            Write-Verbose 'Processing End block'

            #region Output

            #endregion Output
        }
    #endregion end
}
#endregion Set-PSLStoredKey (Function)