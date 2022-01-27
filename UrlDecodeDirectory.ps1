Add-Type -AssemblyName System.Web

foreach ($thing in ls)
{
    $newName = [System.Web.HttpUtility]::UrlDecode($thing.Name)
    if ($thing.name -ne $newName)
    {
        mv $thing.name $newName
    }
}
