# Shutdown Timer

A one-click shutdown timer for Windows. Pick a delay, or cancel a pending shutdown, without touching the command line.

| Version | Files | What it does |
|---|---|---|
| v1 | `src/v1/shutdown-timer.vbs` | Starts a 1-hour timer, or cancels one |
| v2 (current) | `src/v2/shutdown-timer.cmd` | Sets a 15 min / 30 min / 1 h / 2 h timer, or cancels it, from one window |

## Design and implementation

Version 1 is a single VBScript built around a Yes/No/Cancel prompt: Yes starts a fixed 1-hour timer with `shutdown /s /t 3600`, and No cancels a pending one with `shutdown /a`. It waits for each command's exit code so it can report whether it worked, and if a timer is already running when you try to start one, it offers to cancel it. Version 2 is the full tool, packed into a single `.cmd` file that is both a batch script and a PowerShell script. A short batch header starts a hidden PowerShell process, which reads the rest of the same file as code. That code builds a small Windows Forms window with preset buttons (15 minutes, 30 minutes, 1 hour, 2 hours) and a cancel button. Each preset clears any existing timer before scheduling a new one, and the window shows the exact time the PC will shut down. Everything it needs ships with Windows, so there is nothing to install, and it no longer depends on VBScript, which Microsoft is phasing out.

## Usage

- **v1:** double-click `shutdown-timer.vbs`, then click **Yes** to shut down in 1 hour, **No** to cancel a scheduled shutdown, or **Cancel** to close.
- **v2:** **CURRENT** double-click `shutdown-timer.cmd`, then pick a time or click **Cancel timer**. A console window flashes briefly before the timer window opens.
- Windows may warn you the first time because the file came from the internet. Click **More info → Run anyway**, or right-click the file and choose **Properties → Unblock**.
- v2 won't run from a folder whose path contains an apostrophe (`'`).
