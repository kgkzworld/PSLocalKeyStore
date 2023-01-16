#region Build Notes
<#
    o 21.3.301: • [Michael Arroyo] Posted
#>
#endregion Build Notes

#region Main
    #region Create Hash
        $PSLocalKeyStoreInfo = @{}
    #endregion Create Hash

    #region Script File and Path Values
        $PSLocalKeyStoreInfo['PSScriptRoot'] = $PSScriptRoot

        If ( $PSLocalKeyStoreInfo['PSScriptRoot'] -eq '' ) {
            If ( $Host.Name -match 'ISE' ) {
                $PSLocalKeyStoreInfo['PSScriptRoot'] = Split-Path -Path $psISE.CurrentFile.FullPath -Parent
            }
        }
    #endregion Script File and Path Values

    #region Script Settings Values
        $PSLocalKeyStoreInfo['ScriptSettings'] = @{}
        $PSLocalKeyStoreInfo['ScriptSettings']['TimeStamp'] = $('D{0}' -f $(Get-Date -Format dd.MM.yyyy-hh.mm.ss.ff.tt)) -replace '-','_T'
        $PSLocalKeyStoreInfo['ScriptSettings']['CurrentUser'] = $($env:USERNAME)
        $PSLocalKeyStoreInfo['ScriptSettings']['CurrentComputer'] = $env:COMPUTERNAME.ToUpper()
        $PSLocalKeyStoreInfo['ScriptSettings']['WorkingPath'] = $PSLocalKeyStoreInfo.PSScriptRoot
        $PSLocalKeyStoreInfo['ScriptSettings']['LoadedFunctionsPrv'] = @()
        $PSLocalKeyStoreInfo['ScriptSettings']['LoadedFunctionsPub'] = @()
        $PSLocalKeyStoreInfo['ScriptSettings']['LoadedVariablesPub'] = @()
        $PSLocalKeyStoreInfo['ScriptSettings']['LoadedAliasesPub'] = @()
        $PSLocalKeyStoreInfo['ScriptSettings']['Log'] = @()
    #endregion Script Settings Values

    #region Query Private Functions
        $PSLocalKeyStorePrivate = Get-ChildItem -Path $(Join-Path -Path $($PSLocalKeyStoreInfo.ScriptSettings.Workingpath) -ChildPath 'Private') -Filter '*.ps1' -Force -Recurse -ErrorAction SilentlyContinue | Select-Object -Property BaseName,FullName
    #endregion Query Core Path

    #region Query Public Functions
        $PSLocalKeyStorePublic = Get-ChildItem -Path $(Join-Path -Path $($PSLocalKeyStoreInfo.ScriptSettings.Workingpath) -ChildPath 'Public') -Filter '*.ps1' -Force -Recurse -ErrorAction SilentlyContinue | Select-Object -Property BaseName,FullName
    #endregion Query Core Path

    #region Dynamically Build Functions from .PS1 files
        If ( $PSLocalKeyStorePrivate ) {
            $PSLocalKeyStorePrivate | ForEach-Object -Process {
                Try {
                    . $($_ | Select-Object -ExpandProperty FullName)
                    $PSLocalKeyStoreInfo['ScriptSettings']['LoadedFunctionsPrv'] += $($_ | Select-Object -ExpandProperty BaseName)
                } Catch {
                    #Nothing
                }
            }
        }

        If ( $PSLocalKeyStorePublic ) {
            $PSLocalKeyStorePublic | ForEach-Object -Process {
                Try {
                    . $($_ | Select-Object -ExpandProperty FullName)
                    $PSLocalKeyStoreInfo['ScriptSettings']['LoadedFunctionsPub'] += $($_ | Select-Object -ExpandProperty BaseName)
                } Catch {
                    #Nothing
                }
            }
        }
    #endregion Dynamically Build Functions from .PS1 files

    #region Dynamically Build Export Variable list
        $PSLocalKeyStoreInfo['ScriptSettings']['LoadedVariablesPub'] += 'PSLocalKeyStoreInfo'
    #endregion Dynamically Build Export Variable list

    #region Export Module Members
        Export-ModuleMember `
        -Function $($PSLocalKeyStoreInfo['ScriptSettings']['LoadedFunctionsPub']) `
        -Variable $($PSLocalKeyStoreInfo['ScriptSettings']['LoadedVariablesPub']) `
        #-Alias $($BluGenieInfo['ScriptSettings']['LoadedAliases'] | Select-Object -ExpandProperty Name)
    #endregion Export Module Members
#endregion Main