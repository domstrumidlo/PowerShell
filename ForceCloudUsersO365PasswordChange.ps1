#author: Dominik Strumidlo
#dominik@strumidlo.pl
#this script forces cloud (Exchange O365) users to change their password at logon

#Initiates a connection to Azure Active Directory.
Connect-MsolService 
Import-Module ExchangeOnlineManagement
#Initiates a connection to Exchange Online with PowerShell V2 module
Connect-ExchangeOnline -ShowProgress $true 

#Put all (-ALL) users with property UserPrincipalName into variable that are:
#-EnabledFilter EnabledOnly <- only enabled users
#| WHERE IMMUTABLEID -eq $NULL" <- not in on-prem AD (implicates only cloud users)
#{$_.UserType -NE "Guest"}  <- not guests
#{$_.FirstName -NE $NULL } <- filled with name

$Users = GET-MSOLUSER -EnabledFilter EnabledOnly -ALL | WHERE IMMUTABLEID -eq $NULL | ? {$_.UserType -NE "Guest"} | ? {$_.FirstName -NE $NULL } | Select-Object -expandproperty UserPrincipalName 
#variable to make exclude some users
$ExcludedUsers = @();

#Exchange room type users
$ExcludedRoomMailbox =  Get-EXOMailbox -Filter '(RecipientTypeDetails -eq "RoomMailBox")' | Select-Object -expandproperty UserPrincipalName 


#for each user in array make password change
foreach ( $user in $users ) {
    #if user was excluded then skip
    if ($ExcludedUsers.Contains($user)){continue}
    
    #-ForceChangePassword:$true <- random new password, and promnt to change after first logon
    #-ForceChangePassword:$true -ForceChangePasswordOnly:$true <- dont change password, and promnt to change after first logon

Set-MsolUserPassword -UserPrincipalName $user -ForceChangePassword:$true -ForceChangePasswordOnly:$true

}