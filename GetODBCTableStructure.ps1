function GetODBCTableStructure
{
    param([string]$connectionString)
    $conn = New-Object System.Data.Odbc.OdbcConnection
    try
    {
        $conn.ConnectionString = $connectionString
        $conn.Open()
        $columns = $conn.GetSchema("COLUMNS")
        $tables = @{}
        foreach ($row in $columns.rows)
        {
            if (-not $tables.containskey($row["TABLE_NAME"]))
            {
                $tables[$row["TABLE_NAME"]] = New-Object System.Collections.Generic.List[string]
            }
            $tables[$row["TABLE_NAME"]].Add("Column name: $($row["COLUMN_NAME"]),Type name: $($row["TYPE_NAME"])")
        }
        $tables
    }
    catch
    {
        Write-Host $_
    }
    finally
    {
        $conn.Dispose()
    }
}