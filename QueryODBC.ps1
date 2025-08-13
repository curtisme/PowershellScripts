param (
    [Parameter(Mandatory=$true)]
    [string]$ConnectionString,
    
    [Parameter(Mandatory=$true)]
    [string]$Query
)

try {
    $connection = New-Object System.Data.Odbc.OdbcConnection
    $connection.ConnectionString = $ConnectionString
    $connection.Open()

    $command = $connection.CreateCommand()
    $command.CommandText = $Query

    $reader = $command.ExecuteReader()

    while ($reader.Read()) {
        for ($i = 0; $i -lt $reader.FieldCount; $i++) {
            Write-Output ("{0}: {1}" -f $reader.GetName($i), $reader.GetValue($i))
        }
        Write-Output "---"
    }

    $reader.Close()
    $reader.Dispose()
    $command.Dispose()
    $connection.Close()
    $connection.Dispose()
}
catch {
    Write-Output "Error: $_"
}
finally {
    if ($connection -ne $null) {
        if ($connection.State -eq 'Open') {
            $connection.Close()
        }
        $connection.Dispose()
    }
}
