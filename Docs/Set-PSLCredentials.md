# Set-PSLCredentials

## SYNOPSIS
Set Credentials at the command line

## SYNTAX
```
Set-PSLCredentials [-SetUser] <String> [-SetPass] <String> [<CommonParameters>]
```

## DESCRIPTION
Set Credentials without using Get-Credentials and being prompted for a password

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: $Creds = Set-PSLCredentials -UserName 'Guest' -Password 'Password!'
 ``` 
 ```yam 
 Description: Use this command to Set Credentials and save that information to a variable called $Creds
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: $Creds = Set-ScriptCredentials -UserName 'TestDomain\Guest' -Password 'Password!'
 ``` 
 ```yam 
 Description: Use this command to Set Domain Credentials and save that information to a variable called $Creds
Notes: This command uses the Alias command name
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: $Creds = Set-ScriptCredentials -UserName 'TestDomain\Guest' -Password 'Password!'
 ``` 
 ```yam 
 $Creds.ShowPassword()Description: Use this command to show an already saved Cred Password
Notes: This is a known PowerShell method which will expose the current password.
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: $Creds = Get-PSLStoredKey -KeyName 'MyKey' -ConvertFromJson | Set-PSLCredential
 ``` 
 ```yam 
 Description: Use this command to Set Credentials from a Stored Key
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: $Creds = Get-PSLStoredKey -KeyName 'MyKey' | Set-PSLCredential -UserName 'MyDomain\Michael'
 ``` 
 ```yam 
 Description: Use this command to Set Credentials from a Stored Key and change the UserName
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Set-PSLCredentials -Help
 ``` 
 ```yam 
 Description: Use this to show the help system for this function
Notes: If you have the PSWalkthrough Module installed, this will start the dynamic help menu system.  If not it will show the normal
        PowerShell help information for this function.
 ``` 


## PARAMETERS

### SetUser
 ```yam 
 -SetUser <String>
    Description: User Name for the Current Credentials
    Notes: You can set a domain by using "Domain_Name\UserName"
    Alias: 'UserName', 'Usr', 'User', 'Name', 'ID'
    ValidateSet:
    
    Required?                    true
    Position?                    1
    Default value                
    Accept pipeline input?       true (ByValue, ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### SetPass
 ```yam 
 -SetPass <String>
    Description: Password for the Current Credentials
    Notes:
    Alias: 'Password', 'PW', 'Token', 'Pass'
    ValidateSet:
    
    Required?                    true
    Position?                    2
    Default value                
    Accept pipeline input?       true (ByValue, ByPropertyName)
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


