; LabJack driver files for both LJM and UD
;
; Prerequisites:
;  - $INSDIR must be set

Section -labjack_driver_shared
    SetShellVarContext "all"
    SetOverwrite on

    SetOutPath $SYSDIR
    File Files\32-bit\LabJackWUSB.dll

    SetOverwrite off
    File Files\32-bit\winusb.dll
    File Files\32-bit\wzcsvc.dll
    File Files\32-bit\hnetcfg.dll
    SetOverwrite on

    ${If} ${RunningX64}
        ${DisableX64FSRedirection}
        SetOutPath $SYSDIR
        File Files\64-bit\LabJackWUSB.dll

        SetOverwrite off
        File Files\64-bit\winusb.dll
        SetOverwrite on
        ${EnableX64FSRedirection}
    ${EndIf}

    ; Call the Driver Package Installer
    ; https://msdn.microsoft.com/en-us/library/windows/hardware/ff544842(v=vs.85).aspx
    DetailPrint "The following command may take a while..."
    ${If} ${RunningX64}
        ExecWait '"$INSTDIR\Drivers\Install\LabJacka64\dpinst64.exe" /c /sa /f /lm /sw /PATH "$INSTDIR\Drivers\Install\LabJacka64"'
    ${Else}
        ExecWait '"$INSTDIR\Drivers\Install\LabJackx86\dpinst32.exe" /c /sa /f /lm /sw /PATH "$INSTDIR\Drivers\Install\LabJackx86"'
    ${EndIf}
SectionEnd

Section -labjack_driver_shared_dotnet
    SetShellVarContext "all"
    SetOverwrite on

    SetOutPath $INSTDIR\Drivers
    File Files\32-bit\InstallLJNET.exe
    File Files\32-bit\RemoveLJNET.exe
SectionEnd

