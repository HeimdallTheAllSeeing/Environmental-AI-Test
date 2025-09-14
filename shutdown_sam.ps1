# Graceful SAM Shutdown Script
Write-Host "Initiating graceful shutdown of SAM processes..." -ForegroundColor Yellow

# Get all SAM-related processes
$samProcesses = Get-Process | Where-Object {$_.ProcessName -like "*python*" -or $_.ProcessName -like "*sam*"}

if ($samProcesses.Count -eq 0) {
    Write-Host "No SAM processes found running." -ForegroundColor Green
    exit 0
}

Write-Host "Found $($samProcesses.Count) SAM-related processes:"
$samProcesses | Format-Table Id, ProcessName, CPU -AutoSize

# Send graceful shutdown signal
Write-Host "Sending graceful shutdown signals..." -ForegroundColor Yellow
foreach ($process in $samProcesses) {
    try {
        Write-Host "Stopping process $($process.Id) ($($process.ProcessName))..."
        Stop-Process -Id $process.Id
        Write-Host "Process $($process.Id) shutdown initiated" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to stop process $($process.Id): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Shutdown completed." -ForegroundColor Green
