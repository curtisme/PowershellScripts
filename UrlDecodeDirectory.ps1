Add-Type -AssemblyName System.Web

foreach ($thing in ls)
{
    $newName = [System.Web.HttpUtility]::UrlDecode($thing.Name)
    if ($thing.name -ne $newName)
    {
        write-host "renaming ""$($thing.name)"" to ""$newName..."""
        mv $thing.name $newName
    }

    else
    {
        write-host "skipping ""$newName""..."
    }
}
