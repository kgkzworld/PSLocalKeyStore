#region Invoke-PSLRunAs (Function)
function Invoke-PSLRunAs {
    <#
    .SYNOPSIS
        Invoke-PSLRunAs is a function that will run a command as a different user

    .DESCRIPTION
        Invoke-PSLRunAs is a function that will run a command as a different user

    .PARAMETER FilePath
        Description:  The path to the file to run
        Notes:  This is a required parameter.  It's always a good idea to use the full path to the file.
				Example: C:\Windows\System32\cmd.exe
							Instead of: cmd.exe
        Alias: File, Path, Command, Cmd
        ValidateSet:

	.PARAMETER ArgumentList
        Description: The arguments to pass to the command
        Notes: This is a optional parameter
        Alias: Args, Arg
        ValidateSet:

	.PARAMETER Credential
        Description: The credentials to use to run the command
        Notes: Credentials have to be passed in as a PSCredential object.
			If you want to use a string as the username and password for the credentials, use the following command:
				$Creds = Set-PSLCredential -UserName 'MyDomain\MyUser' -Password 'MyPassword'

			You can also pass in the username and password from a Secret JSON string:
				$Creds = Get-PSLStoredKey -KeyName 'MyKey' | ConvertFrom-Json | Set-PSLCredential

			You can also use the following command to prompt for the username and password:
				$Creds = Get-Credential
        Alias:
        ValidateSet:

	.PARAMETER Wait
        Description: Wait for the command to finish before returning
        Notes: By default the command will run in the foreground and return to the calling process immediately.
			If you want to wait for the command to finish, use this switch.
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes: This is a switch parameter
        Alias: Help
        ValidateSet:

    .EXAMPLE
        Command: Invoke-PSLRunAs -FilePath 'C:\Windows\System32\cmd.exe' -ArgumentList '/c dir' -Credential $Creds -Wait
        Description: Run the command prompt as a different user
        Notes: This will run the command prompt as a different user and wait for the command to finish before returning.
        Output:

	.EXAMPLE
        Command: Invoke-PSLRunAs -FilePath 'C:\Windows\System32\cmd.exe' -ArgumentList '/c dir' -Credential $Creds
        Description: Run the command prompt as a different user
        Notes: This will run the command prompt as a different user and return to the calling process immediately.
        Output:

	.EXAMPLE
        Command: Get-PSLStoredKey -KeyName 'MyKey' -ConvertFromJSON | Set-PSLCredentials | Invoke-PSLRunAs 'C:\Windows\System32\cmd.exe'
        Description: Query a secret JSON string for the username and password and run a command as that user
        Notes: The JSON secret string should be in a similar format:
			'{"Name":"MyDomain\Michael","Token":"3a48e249-49d4-469c-92fa-1f2956a7f609","Password":"Password!","Description":"Example Key"}'
        Output:

    .EXAMPLE
        Command: Invoke-PSLRunAs -Help
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
    [Alias('PSLRunAs')]
    #region Parameters
        Param (
            [Parameter(Position=0,
				ValueFromPipelineByPropertyName = $True)]
			[Alias('Path','File','Command','Cmd')]
			[string]$FilePath,

			[Parameter(Position=1,
				ValueFromPipelineByPropertyName = $True)]
			[Alias('Arg','Args')]
			[string]$ArgumentList,

			[Parameter(Position=2,
				ValueFromPipeline = $true,
				ValueFromPipelineByPropertyName = $True)]
			[System.Management.Automation.PSCredential]$Credential,

			[switch]$Wait,

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
                $StartProcessProps = @{
					'PassThru' = $true
					'FilePath' = $('{0}\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -f $Env:SystemDrive)
					'Credential' = $Credential
				}

				$ArrArgumentList = @(
					'-WindowStyle hidden -noprofile -command &{Start-Process ',
					"$FilePath",
					' -Wait -verb runas'
				)

				Switch ( $Null ) {
					{ $ArgumentList } {
						$ArrArgumentList +=  $(" -ArgumentList '{0}'{1}" -f $ArgumentList, '}')
					}
					{ -Not $ArgumentList } {
						$ArrArgumentList +=  '}'
					}
				}

				$StartProcessProps.ArgumentList = $($ArrArgumentList -Join '')

				$ps = Start-Process @StartProcessProps
            #endregion Main
        }
    #endregion process

    #region end
        end {
            Write-Verbose 'Processing End block'

            #region Output
                If ( $Wait ) {
					$ps.WaitForExit()
				}
            #endregion Output
        }
    #endregion end
}
#endregion Invoke-PSLRunAs (Function)