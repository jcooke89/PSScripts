param ( [string]$ENVNAME = "" )
$eventLogSource = "CleanUpLogs"
$logName = "Application"
try {
    $ScriptPath = 'c:\justeat\bootstrapping\psscripts\logCleaner.ps1'
    #$Time = '9:00AM'
    $TaskName = 'clean-up-files'
    $PowerShellLocation = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    $Arguments = "-File `"$ScriptPath`" -ENVNAME `"$ENVNAME`" -NoLogo -NonInteractive -NoProfile"
    $Description = 'Runs PS script to remove old files after x number of days'

    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionDuration (New-TimeSpan -Days 3000) -RepetitionInterval (New-TimeSpan -Minutes 1)
    $action = New-ScheduledTaskAction -Execute $PowerShellLocation -Argument $Arguments
    $TaskUserName = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    $task = New-ScheduledTask -Action $action -Trigger $trigger -Description $Description -Principal $TaskUserName

    Write-EventLog -LogName $logName -Source $eventLogSource -EntryType "Information" -EventId 0 -Message "Scheduling Log cleaner Task"

    Register-ScheduledTask -InputObject $task -TaskName $TaskName
}
catch {
    Write-EventLog -LogName $logName -Source $eventLogSource -EntryType "Error" -EventId 0 -Message "Failed to schedule log cleaner task"
}