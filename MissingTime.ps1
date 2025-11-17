param(
    [Parameter(Mandatory=$true)]
    [string]$CsvPath,

    [Parameter(Mandatory=$false)]
    [string]$OutputPath
)

$TARGET_TOTAL = 7.5

try {
    $data = Import-Csv -Path $CsvPath
} catch {
    Write-Error "Failed to read CSV: $_"
    exit 1
}

if (-not ($data | Get-Member -Name "task", "time")) {
    Write-Error "CSV must have 'task' and 'time' columns."
    exit 1
}

$entries = $data | ForEach-Object {
    $raw = $_.time.Trim()
    $hours = if ([string]::IsNullOrWhiteSpace($raw)) {
        $null
    } elseif ($raw -match '^\d+(\.\d+)?$') {
        [double]$raw
    } elseif ($raw -match '^(\d+):(\d{2})$') {
        [double]$matches[1] + [double]$matches[2]/60
    } else {
        Write-Warning "Invalid time format '$raw' for task '$($_.task)' - treated as missing"
        $null
    }
    [PSCustomObject]@{
        Task = $_.task
        Time = $hours
        Original = $raw
    }
}

$knownTotal = ($entries | Where-Object { $_.Time -ne $null } | Measure-Object -Property Time -Sum).Sum
$missingCount = ($entries | Where-Object { $_.Time -eq $null }).Count

if ($missingCount -eq 0) {
    Write-Host "All times already filled. Total: $knownTotal hours" -ForegroundColor Yellow
    $remaining = 0
} else {
    $remaining = $TARGET_TOTAL - $knownTotal
    if ($remaining -lt 0) {
        Write-Warning "Known time ($knownTotal hrs) exceeds target ($TARGET_TOTAL hrs). Will not reduce."
        $remaining = 0
    } elseif ($remaining -eq 0) {
        Write-Host "Known time exactly matches target. Filling blanks with 0." -ForegroundColor Green
    } else {
        Write-Host "Filling $missingCount missing entries to reach $TARGET_TOTAL hrs (need $remaining more)" -ForegroundColor Cyan
    }
}

$fillValue = if ($missingCount -gt 0 -and $remaining -gt 0) {
    [math]::Round($remaining / $missingCount, 3)
} else {
    0
}

$result = $entries | ForEach-Object {
    if ($null -eq $_.Time) {
        $_.Time = $fillValue
    }
    $formatted = "{0:N2}" -f $_.Time
    [PSCustomObject]@{
        task = $_.Task
        time = $formatted
    }
}

if (-not $OutputPath) {
    $OutputPath = $CsvPath -replace '\.csv$', '_filled.csv'
}

$result | Export-Csv -Path $OutputPath -NoTypeInformation

$finalTotal = ($result | Measure-Object -Property time -Sum).Sum
$status = if ([math]::Abs($finalTotal - $TARGET_TOTAL) -lt 0.01) { "SUCCESS" } else { "ADJUSTED" }
Write-Host "`n${status}: Total time = $finalTotal hours → Saved to: $OutputPath" -ForegroundColor Green
