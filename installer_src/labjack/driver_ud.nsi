; LabJack driver files for UD
;
; Prerequisites:
;  - $INSDIR must be set
;  - `!include labjack\driver_shared.nsi` must happen before this is `!include`d

Section -labjack_driver_ud_base
    SetShellVarContext "all"
    SetOverwrite on

    SetOutPath $INSTDIR\Drivers
    File Files\32-bit\LabJackUD.h
    File Files\32-bit\LabJackUD.lib

    SetOutPath $INSTDIR\Drivers\64bit
    File Files\64-bit\LabJackUD.lib

    SetOutPath $SYSDIR
    File Files\32-bit\LabJackUD.dll

    ${If} ${RunningX64}
        ${DisableX64FSRedirection}
        SetOutPath $SYSDIR
        File Files\64-bit\LabJackUD.dll
        ${EnableX64FSRedirection}
    ${EndIf}
SectionEnd


Section -labjack_driver_ud_dotnet
    SetShellVarContext "all"
    SetOverwrite on

    SetOutPath $INSTDIR\Drivers
    File Files\32-bit\LJUDDotNet.dll

    SetOutPath $INSTDIR\Drivers\Install
    File /r Files\Install\*

    WriteRegStr HKLM "SOFTWARE\Microsoft\.NETFramework\AssemblyFolders\LJUDDotNet" "" "$INSTDIR\Drivers"
    WriteRegStr HKLM "SOFTWARE\Microsoft\.NETFramework\v2.0.50727\AssemblyFoldersEx\LJUDDotNet" "" "$INSTDIR\Drivers"

    ExecWait '$INSTDIR\Drivers\InstallLJNET.exe "$INSTDIR\Drivers\LJUDDotNet.dll"'
SectionEnd

