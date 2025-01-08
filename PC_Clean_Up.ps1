# PowerShell script to run commands with messages and wait intervals

# Check and handle execution policy
$currentPolicy = Get-ExecutionPolicy
if ($currentPolicy -ne 'Unrestricted' -and $currentPolicy -ne 'Bypass') {
    Write-Host "Current execution policy is $currentPolicy. Changing to Bypass for this session..."
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
}

# Function to run a command with a message and wait
function Run-Process {
    param (
        [string]$command,
        [string]$message,
        [int]$waitTime = 5
    )
    Write-Host $message
    Start-Sleep -Seconds $waitTime
    Invoke-Expression $command
}

# List of commands and messages
$commands = @(
    @{ command = "ipconfig /flushdns"; message = "Clearing DNS Records please wait" },
    @{ command = "wevtutil cl System"; message = "Clearing Windows event logs" },
    @{ command = "RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255"; message = "Clearing Browser History" },
    @{ command = "fsutil usn deletejournal /d /n C:"; message = "Deleting the record of files and folder changes and file system activities" },
    @{ command = "del /f /s /q $env:TEMP\*.*"; message = "Deleting temporary files to clear system and application traces" },
    @{ command = "netsh interface ipv4 reset"; message = "Deleting network configuration history" },
    @{ command = "del /q/f/s $env:SystemRoot\System32\spool\PRINTERS\*"; message = "Clearing printer cache" },
    @{ command = "del /q/f/s $env:SystemRoot\Prefetch\*"; message = "Clearing prefetch cache" },
    @{ command = "del /q/f/s $env:SystemRoot\Temp\*"; message = "Clearing temp cache" }
)

# Execute each command
foreach ($cmd in $commands) {
    Run-Process -command $cmd.command -message $cmd.message
}

# Show a message box after all commands are executed
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("ALL COMMANDS RUN SUCCESSFULLY, EXITING...", "Completion", 'OK', 'Information')

# Exit PowerShell
exit