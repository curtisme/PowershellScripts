param (
    [Parameter(Mandatory=$true)]
    [string]$Text,
    [int]$DelaySeconds = 3
)

Add-Type -AssemblyName System.Windows.Forms

function AutoType-Text {
    param (
        [string]$InputText
    )
    
    $chars = $InputText.ToCharArray()
    
    foreach ($char in $chars) {
        [System.Windows.Forms.SendKeys]::SendWait($char)
        Start-Sleep -Milliseconds 50
    }
}

Write-Host "Typing will start in $DelaySeconds seconds..."
Start-Sleep -Seconds $DelaySeconds

AutoType-Text -InputText $Text

Write-Host "Typing completed!"
