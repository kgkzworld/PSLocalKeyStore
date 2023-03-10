# Set-PSLStoredKey

## SYNOPSIS
Set-PSLStoredKey is a function that will retrieve a stored key from the current user's KeyStore

## SYNTAX
```
Set-PSLStoredKey [[-Secret] <String>] [-SecureSecret <SecureString>] [[-KeyName] <String>] [-Force] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-PSLStoredKey is a function that will retrieve a stored key from the current user's KeyStore

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-PSLStoredKey -KeyName 'MyKey' -Secret 'MySecret'
 ``` 
 ```yam 
 Description: Use this command to store a key in the KeyStore
Notes: This command will store the key in the KeyStore.  Only the current user will be able to access this key.
Output:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: '{"Name":"MyDomain\Michael","Token":"3a48e249-49d4-469c-92fa-1f2956a7f609","Password":"Password!","Description":"Example Key"}' | `
 ``` 
 ```yam 
 Set-PSLStoredKey -KeyName 'MyKey'Description: Pipe a JSON string to this command to store a key in the KeyStore
Notes: This command will store the key in the KeyStore.  Only the current user will be able to access this key.
    The JSON string can be any valid JSON string.
Output:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-PSLStoredKey -Help
 ``` 
 ```yam 
 Description: Use this to show the help system for this function
Notes: If you have the PSWalkthrough Module installed, this will start the dynamic help menu system.  If not it will show the normal
        PowerShell help information for this function.
 ``` 


## PARAMETERS

### Secret
 ```yam 
 -Secret <String>
    Description:  The secret to store in the KeyStore
    Notes:  This is a required parameter
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       true (ByValue)
    Accept wildcard characters?  false
 ``` 
### SecureSecret
 ```yam 
 -SecureSecret <SecureString>
    Description: The secure secret to store in the KeyStore
    Notes: This is an optional parameter and is using the SecureString type
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### KeyName
 ```yam 
 -KeyName <String>
    Description: The name of the key to store in the KeyStore
    Notes: This is a required parameter
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Force
 ```yam 
 -Force [<SwitchParameter>]
    Description:  Force the key to be stored in the KeyStore and overwrite any existing key
    Notes: This is a switch parameter
    Alias:
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


