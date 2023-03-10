# Invoke-PSLRunAs

## SYNOPSIS
Invoke-PSLRunAs is a function that will run a command as a different user

## SYNTAX
```
Invoke-PSLRunAs [[-FilePath] <String>] [[-ArgumentList] <String>] [[-Credential] <PSCredential>] [-Wait] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Invoke-PSLRunAs is a function that will run a command as a different user

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Invoke-PSLRunAs -FilePath 'C:\Windows\System32\cmd.exe' -ArgumentList '/c dir' -Credential $Creds -Wait
 ``` 
 ```yam 
 Description: Run the command prompt as a different user
Notes: This will run the command prompt as a different user and wait for the command to finish before returning.
Output:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Invoke-PSLRunAs -FilePath 'C:\Windows\System32\cmd.exe' -ArgumentList '/c dir' -Credential $Creds
 ``` 
 ```yam 
 Description: Run the command prompt as a different user
Notes: This will run the command prompt as a different user and return to the calling process immediately.
Output:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-PSLStoredKey -KeyName 'MyKey' -ConvertFromJSON | Set-PSLCredentials | Invoke-PSLRunAs 'C:\Windows\System32\cmd.exe'
 ``` 
 ```yam 
 Description: Query a secret JSON string for the username and password and run a command as that user
Notes: The JSON secret string should be in a similar format:
'{"Name":"MyDomain\Michael","Token":"3a48e249-49d4-469c-92fa-1f2956a7f609","Password":"Password!","Description":"Example Key"}'
Output:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Invoke-PSLRunAs -Help
 ``` 
 ```yam 
 Description: Use this to show the help system for this function
Notes: If you have the PSWalkthrough Module installed, this will start the dynamic help menu system.  If not it will show the normal
        PowerShell help information for this function.
 ``` 


## PARAMETERS

### FilePath
 ```yam 
 -FilePath <String>
    Description:  The path to the file to run
    Notes:  This is a required parameter.  It's always a good idea to use the full path to the file.
    Example: C:\Windows\System32\cmd.exe
    Instead of: cmd.exe
    Alias: File, Path, Command, Cmd
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### ArgumentList
 ```yam 
 -ArgumentList <String>
    Description: The arguments to pass to the command
    Notes: This is a optional parameter
    Alias: Args, Arg
    ValidateSet:
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### Credential
 ```yam 
 -Credential <PSCredential>
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
    
    Required?                    false
    Position?                    3
    Default value                
    Accept pipeline input?       true (ByValue, ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### Wait
 ```yam 
 -Wait [<SwitchParameter>]
    Description: Wait for the command to finish before returning
    Notes: By default the command will run in the foreground and return to the calling process immediately.
    If you want to wait for the command to finish, use this switch.
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


