; Uninstall LabJack driver files for LJM

Section -un.labjack_driver_ljm_base
    Delete /REBOOTOK $INSTDIR\Drivers\LabJackM.h
    Delete /REBOOTOK $INSTDIR\Drivers\LabJackM.lib
    Delete /REBOOTOK $SYSDIR\LabJackUD.dll
    Delete /REBOOTOK $SYSDIR\LabJackM.dll

    Delete $INSTDIR\Drivers\LabJackM.h
    Delete $INSTDIR\Drivers\LabJackM.lib
    Delete $INSTDIR\Drivers\64bit\LabJackM.lib

    ${If} ${RunningX64}
        ${DisableX64FSRedirection}
        Delete /REBOOTOK $SYSDIR\LabJackM.dll
        ${EnableX64FSRedirection}
    ${EndIf}
SectionEnd


Section -un.labjack_driver_ljm_dotnet
    Delete /REBOOTOK $INSTDIR\Drivers\LabJack.LJM.dll
    DeleteRegKey /IfEmpty HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\.NETFramework\AssemblyFolders\LabJack.LJM"
    DeleteRegKey /IfEmpty HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\.NETFramework\v2.0.50727\AssemblyFoldersEx\LabJack.LJM"
SectionEnd


Section -un.labjack_driver_ljm_data
    SetShellVarContext "all"
    RmDir /r /REBOOTOK "$APPDATA\LabJack\LJM"
SectionEnd

