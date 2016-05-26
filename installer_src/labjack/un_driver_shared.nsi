
Section -un.labjack_driver_shared
    Delete /REBOOTOK $SYSDIR\LabJackWUSB.dll

    ${If} ${RunningX64}
        ${DisableX64FSRedirection}
        Delete /REBOOTOK $SYSDIR\LabJackWUSB.dll
        ${EnableX64FSRedirection}
    ${EndIf}

    RmDir /r /REBOOTOK $INSTDIR\Drivers\Install
    RmDir /r /REBOOTOK $INSTDIR\Drivers\64-bit
    RmDir /r /REBOOTOK $INSTDIR\Drivers
SectionEnd


; Prerequisites:
;   - un.labjack_driver_ljm_dotnet
;   - un.labjack_driver_ud_dotnet
Section -un.labjack_driver_shared_dotnet
    Delete /REBOOTOK $INSTDIR\Drivers\InstallLJNET.exe
    Delete /REBOOTOK $INSTDIR\Drivers\RemoveLJNET.exe

    DeleteRegKey /IfEmpty HKEY_LOCAL_MACHINE SOFTWARE\Microsoft\.NETFramework\AssemblyFolders
    DeleteRegKey /IfEmpty HKEY_LOCAL_MACHINE SOFTWARE\Microsoft\.NETFramework
    DeleteRegKey /IfEmpty HKEY_LOCAL_MACHINE SOFTWARE\Microsoft
SectionEnd


Section -un.labjack_legacy
    ; Old LabJack uninstallers
    Delete /REBOOTOK "$INSTDIR\uninstallLJUD.exe"
    Delete /REBOOTOK "$INSTDIR\uninstallLJUDM.exe"
SectionEnd

