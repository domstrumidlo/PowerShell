#author: Dominik Strumidlo
#script recurivly searches for content of specific files in given directory and change strings
$SearchPath = ""
$filesArray = New-Object System.Collections.Generic.List[System.Object]


#get files in directory
function directorySearch($directoryPath = $pwd, [string[]]$exclude)
{
    foreach ($item in Get-ChildItem $directoryPath)
    {
        if ($exclude | Where {$item -like $_}) { continue }
        if (Test-directoryPath $item.FullName -directoryPathType Container)
        {
            $filesArray.Add($item.FullName)
            directorySearch $item.FullName $exclude
        }
    }
} 

#function call
directorySearch($SearchPath)

$oldString = "aa"
$newString = "bb"
#in each folder search for file with name, and change extension
foreach ($items in $filesArray)
{
    $fulldirectoryPath = $items + $oldString #ex. files with extension
    $filenames = @(get-childitem -directoryPath $fulldirectoryPath | % { $_.FullName })
    
        foreach ($file in $filenames) 
        {
            $replacementStr = $newString #ex. new extension
           (Get-Content $file) | Foreach-object { $_ -replace $oldString , $replacementStr   } | Set-Content $file
             Write-Host Processed $file #write changes
       }
}
