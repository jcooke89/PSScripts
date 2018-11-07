param ( [string]$ENVNAME = "" )
$BasePath = "c:\justeat\$ENVNAME\*\moneycapture\logs"
$AdyenLogsFilePath = "$BasePath\adyen"
$CybsLogsFilePath = "$BasePath\cybersource"
$CsvLogsFilePath = "$BasePath\csv"
$MaxFileAgeDays = 7
$logName = "Application"
$eventLogSource = "CleanUpLogs"

$Paths = @("$AdyenLogsFilePath","$CybsLogsFilePath", "$CsvLogsFilePath")
ForEach($Path in $Paths)
{
    try{
        Write-EventLog -LogName $logName -Source $eventLogSource -EntryType "Information" -EventId 0 -Message "Attempting to delete logs older than $MaxFileAgeDays days in $Path..."
        Get-ChildItem -Path $Path -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddMinutes(-1))} | Remove-Item
        Write-EventLog -LogName $logName -Source $eventLogSource -EntryType "Information" -EventId 0 -Message "Deleted logs older than $MaxFileAgeDays days in $Path"
    }
    catch
    {
        Write-EventLog -LogName $logName -Source $eventLogSource -EntryType "Error" -EventId 0 -Message "Failed to delete old logs from $Path, $_.Exception.ToString()"
    }
}