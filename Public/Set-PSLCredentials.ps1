 #region Set-PSLCredentials (Function)
Function Set-PSLCredentials {
<#
    .SYNOPSIS
        Set Credentials at the command line

    .DESCRIPTION
        Set Credentials without using Get-Credentials and being prompted for a password

    .PARAMETER SetUser
        Description: User Name for the Current Credentials
        Notes: You can set a domain by using "Domain_Name\UserName"
        Alias: 'UserName', 'Usr', 'User', 'Name', 'ID'
        ValidateSet:

    .PARAMETER SetPass
        Description: Password for the Current Credentials
        Notes:
        Alias: 'Password', 'PW', 'Token', 'Pass'
        ValidateSet:

    .EXAMPLE
        Command: $Creds = Set-PSLCredentials -UserName 'Guest' -Password 'Password!'
        Description: Use this command to Set Credentials and save that information to a variable called $Creds
        Notes:

    .EXAMPLE
        Command: $Creds = Set-ScriptCredentials -UserName 'TestDomain\Guest' -Password 'Password!'
        Description: Use this command to Set Domain Credentials and save that information to a variable called $Creds
        Notes: This command uses the Alias command name

    .EXAMPLE
        Command: $Creds = Set-ScriptCredentials -UserName 'TestDomain\Guest' -Password 'Password!'
                    $Creds.ShowPassword()
        Description: Use this command to show an already saved Cred Password
        Notes: This is a known PowerShell method which will expose the current password.

    .EXAMPLE
        Command: $Creds = Get-PSLStoredKey -KeyName 'MyKey' -ConvertFromJson | Set-PSLCredential
        Description: Use this command to Set Credentials from a Stored Key
        Notes:

    .EXAMPLE
        Command: $Creds = Get-PSLStoredKey -KeyName 'MyKey' | Set-PSLCredential -UserName 'MyDomain\Michael'
        Description: Use this command to Set Credentials from a Stored Key and change the UserName
        Notes:

    .EXAMPLE
        Command: Set-PSLCredentials -Help
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
    [Alias('ScriptCredentials','SetCred')]
    #region Parameters
        Param
        (
            [Parameter(
				Mandatory = $true,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                Position = 0
            )]
            [Alias('UserName','Usr','User','Name','ID')]
            [String]$SetUser,

            [Parameter(
                    Mandatory = $true,
                    ValueFromPipeline = $true,
                    ValueFromPipelineByPropertyName = $true,
                    Position = 1
            )]
            [Alias('Password','PW','Token','Pass')]
            [String]$SetPass
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
                $Creds = New-Object -TypeName System.Management.Automation.PSCredential `
                    -ArgumentList "$SetUser", ("$SetPass" | ConvertTo-SecureString -AsPlainText -Force)

                $Creds | Add-Member -MemberType ScriptMethod -Name "ShowPassword" -Value {$this.GetNetworkCredential().Password} -Force

                $Creds | Add-Member -MemberType ScriptMethod -Name "Validate" -Value {
                    If((new-object directoryservices.directoryentry "",$this.UserName,$this.GetNetworkCredential().Password).psbase.name -ne $null) {
                        Write-Host "Password is valid!" -ForegroundColor Green
                    } Else {
                        Write-Host "Sorry! Either user name or password is wrong!" -ForegroundColor Red -BackgroundColor Yellow
                    }
                } -Force
            #endregion Main
        }
    #endregion process

    #region end
        end {
            Write-Verbose 'Processing End block'

            #region Output
                Return $Creds
            #endregion Output
        }
    #endregion end
}
#endregion Set-PSLCredentials (Function)