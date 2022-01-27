Add-Type -AssemblyName System.Web

foreach ($thing in ls)
{
    mv $thing.name ([System.Web.HttpUtility]::UrlDecode($thing.Name))
}
