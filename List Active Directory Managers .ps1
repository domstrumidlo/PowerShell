#author: Dominik Strumidlo
#Script searches specific container in AD and search managers
#tier of manager are searched by titles in variables
#director
#managers
#leaders


$baseparams = @{
  "Filter" = "Enabled -eq 'True' " #Enabled Users
  "SearchBase" = "ou=myusers,DC=contoso,dc=com" #comment this out for global search
}

$params = @{
  "Properties" = "Manager"
}

#all active users
$users = Get-ADUser @baseparams

[String]$manager = ""
[String]$ManagerPrincipalName = ""
$managers = [System.Collections.ArrayList]::new()
$emptyManagers = [System.Collections.ArrayList]::new()
$director = [System.Collections.ArrayList]::new()
$managers = [System.Collections.ArrayList]::new()
$leaders = [System.Collections.ArrayList]::new()
$OtherManagerTitles = [System.Collections.ArrayList]::new()
[int]$i = 0 

foreach ($user in $users) {
    #get user manager
    $params.LDAPFilter = "(sAMAccountName=$($user.SamAccountName))"
    $manager = Get-ADUser @params | ft Manager -HideTableHeaders | Out-String
    $manager = $manager.trim() #whitespace remove


    #if manager exists
    if ($manager){
        #get UserPricinpalName for exisiting manager                                                           
        $ManagerPrincipalName = Get-AdUser -Filter * -SearchBase "$manager"| ft  UserPrincipalName -HideTableHeaders | Out-String                 
        $ManagerTitle = Get-AdUser -Filter * -SearchBase "$manager" -Properties * | Select-Object "Title" | ft -HideTableHeaders | Out-String 

        $ManagerPrincipalName = $ManagerPrincipalName.trim() #whitespace remove
        $ManagerTitle = $ManagerTitle.trim().ToLower() #whitespace remove, make it case insensitive

        #remove duplicates and add to list
        if (!($ManagerPrincipalName -in $managers)) {
            $managers += $ManagerPrincipalName

            if ($ManagerTitle -like "*lider*") {
                    $leaders += $ManagerPrincipalName
            }elseif (($ManagerTitle -like "*kierowni*") -or ($ManagerTitle -like "*manager*") -or ($ManagerTitle -like "*manadżer*") -or ($ManagerTitle -like "*menadżer*")){
                $managers += $ManagerPrincipalName
            }elseif ($ManagerTitle -like "*dyrektor*"){
                     $director += $ManagerPrincipalName
             }else{
               $OtherManagerTitles += $ManagerPrincipalName
               }
            }

    }else { #manager does not exist
    $i = $i+ 1  #counter
     $manager = Get-ADUser @params | ft UserPrincipalName -HideTableHeaders | Out-String
      $manager = $manager.trim() #whitespace remove
     $emptyManagers += $manager #put users without manager into array
    }
    $manager = $null #clear
}

echo $managers
echo ""
echo "users without manager: $i "
echo ""
echo $emptyManagers
echo ""
echo director
echo $director
echo ""
echo managers
echo $managers
echo ""
echo leaders
echo $leaders
echo ""
echo OtherTitles
echo $OtherManagerTitles