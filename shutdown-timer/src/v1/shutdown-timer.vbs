Option Explicit
Dim choice, objShell, exitCode
Set objShell = CreateObject("WScript.Shell")

choice = MsgBox("Yes:  start a 1-hour shutdown timer" & vbCrLf & _
                "No:  cancel a scheduled shutdown" & vbCrLf & _
                "Cancel:  close", vbYesNoCancel + vbQuestion, "Shutdown Timer")

If choice = vbYes Then
    exitCode = objShell.Run("shutdown /s /t 3600", 0, True)
    If exitCode = 0 Then
        MsgBox "Timer started. Computer will shut down in 60 minutes.", vbInformation, "Confirmed"
    ElseIf MsgBox("A shutdown is already scheduled. Do you want to cancel it?", vbYesNo + vbExclamation, "Timer Already Running") = vbYes Then
        CancelShutdown
    End If
ElseIf choice = vbNo Then
    CancelShutdown
End If

Sub CancelShutdown
    exitCode = objShell.Run("shutdown /a", 0, True)
    If exitCode = 0 Then
        MsgBox "Shutdown timer has been canceled.", vbInformation, "Canceled"
    Else
        MsgBox "No scheduled shutdown was found.", vbExclamation, "Nothing to Cancel"
    End If
End Sub
