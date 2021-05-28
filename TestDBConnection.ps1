function TestDBConnection
{
	param([string]$dbProvider, [string]$connectionString)
	$conn = switch($dbProvider)
	{
		"odbc"
		{
			New-Object System.Data.Odbc.OdbcConnection
			break
		}
		"oledb"
		{
			New-Object System.Data.Oledb.OledbConnection
			break
		}
		default
		{
			New-Object System.Data.SqlClient.SqlConnection
		}
	}
	try
	{
		$conn.ConnectionString = $connectionString
		$conn.Open()
		$conn.Close()
		Write-Host "Succesfully connected"
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