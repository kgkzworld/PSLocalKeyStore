# Remove-PSLStoredKey

## SYNOPSIS
Remove-PSLStoredKey is a function that will remove a stored secret for a specified key name.

## SYNTAX
```
Remove-PSLStoredKey [[-KeyName] <String>] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Remove-PSLStoredKey is a function that will remove a stored secret for a specified key name.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Remove-PSLStoredKey -KeyName 'MyKey'
 ``` 
 ```yam 
 Description: Removes the secret for the key 'MyKey'
Notes: Process returns True if the key was removed successfully, False if the key was not found
Output:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Remove-PSLStoredKey -Help
 ``` 
 ```yam 
 Description: Use this to show the help system for this function
Notes: If you have the PSWalkthrough Module installed, this will start the dynamic help menu system.  If not it will show the normal
        PowerShell help information for this function.
 ``` 


## PARAMETERS

### KeyName
 ```yam 
 -KeyName <String>
    Description:  The Name of the Key to remove the secret for
    Notes: This is a required parameter
    Alias: Name
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
    Notes: This is a switch parameter
    Alias: Help
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


