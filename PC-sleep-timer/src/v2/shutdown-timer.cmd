<# :
@echo off
start "" powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "iex (Get-Content -Raw -LiteralPath '%~f0')"
exit /b
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Shutdown Timer"
$form.Size = New-Object System.Drawing.Size(300, 260)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.TopMost = $true

$title = New-Object System.Windows.Forms.Label
$title.Text = "Shut down in..."
$title.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(95, 10)
$form.Controls.Add($title)

$status = New-Object System.Windows.Forms.Label
$status.Text = "No timer set from this window."
$status.Size = New-Object System.Drawing.Size(270, 35)
$status.Location = New-Object System.Drawing.Point(10, 180)
$status.TextAlign = "MiddleCenter"
$form.Controls.Add($status)

function Set-ShutdownTimer([int]$minutes) {
    & shutdown.exe /a 2>$null | Out-Null
    & shutdown.exe /s /t ($minutes * 60) 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $at = (Get-Date).AddMinutes($minutes).ToString("t")
        $status.Text = "Shutdown scheduled in $minutes min (at $at)."
    } else {
        $status.Text = "Failed to schedule (code $LASTEXITCODE)."
    }
}

function Stop-ShutdownTimer {
    & shutdown.exe /a 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $status.Text = "Shutdown timer canceled." }
    else                     { $status.Text = "No scheduled shutdown to cancel." }
}

$options = @(
    @("15 min", 15, 20, 45), @("30 min", 30, 150, 45),
    @("1 hour", 60, 20, 90), @("2 hours", 120, 150, 90)
)
foreach ($o in $options) {
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $o[0]
    $b.Tag = $o[1]
    $b.Size = New-Object System.Drawing.Size(115, 38)
    $b.Location = New-Object System.Drawing.Point($o[2], $o[3])
    $b.Add_Click({ Set-ShutdownTimer $this.Tag })
    $form.Controls.Add($b)
}

$cancel = New-Object System.Windows.Forms.Button
$cancel.Text = "Cancel timer"
$cancel.Size = New-Object System.Drawing.Size(245, 38)
$cancel.Location = New-Object System.Drawing.Point(20, 135)
$cancel.BackColor = [System.Drawing.Color]::IndianRed
$cancel.ForeColor = [System.Drawing.Color]::White
$cancel.Add_Click({ Stop-ShutdownTimer })
$form.Controls.Add($cancel)

[void]$form.ShowDialog()
