# Get-PSLStoredKey

## SYNOPSIS
Get-PSLStoredKey is a function that will return a stored secret for a specified key name.

## SYNTAX
```
Get-PSLStoredKey [[-KeyName] <String>] [-ConvertFromJSON] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Get-PSLStoredKey is a function that will return a stored secret for a specified key name.

Secrets are saved using the Set-PSLStoredKey function and are stored in an encypted string in the user's registry hive.

Note:  This does not use Microsoft's Credential Store to store the secret.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-PSLStoredKey -KeyName 'MyKey'
 ``` 
 ```yam 
 Description: Use this to retrieve the secret for the key 'MyKey'
Notes: To Create a Key, use the Set-PSLStoredKey function
        '{"Name":"MyDomain\\Michael","Token":"3a48e249-49d4-469c-92fa-1f2956a7f609","Password":"Password!","Description":"Example Key"}' | `
        Set-PSLStoredKey -KeyName 'MyKey'

        Note:  The above example is a JSON string that is being piped to the Set-PSLStoredKey function.  The JSON string is then
                converted to a Secure String and stored in the registry as an encrypted string.

                If you don't want to pipe the JSON string to the Set-PSLStoredKey function, you can also use the following command:
                Set-PSLStoredKey -KeyName 'MyKey' and you will be prompted to enter the JSON string in a secure manner.
Output: {"Name":"MyDomain\\Michael","Token":"3a48e249-49d4-469c-92fa-1f2956a7f609","Password":"Password!","Description":"Example Key"}
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-PSLStoredKey -KeyName 'MyKey' -ConvertFromJSON
 ``` 
 ```yam 
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
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-PSLStoredKey -Help
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
    Description:  The Name of the Key to retrieve the secret for
    Notes:  This is a required parameter
    Alias: Key
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ConvertFromJSON
 ```yam 
 -ConvertFromJSON [<SwitchParameter>]
    Description:  Convert the returned value from JSON to a PowerShell Object
    Notes: This is a switch parameter
    Alias: JSON
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
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


