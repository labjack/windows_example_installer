; Uninstall LabJack driver files for UD

Section -un.labjack_driver_ud_base
    Delete /REBOOTOK $INSTDIR\Drivers\64bit\LabJackUD.lib
    Delete /REBOOTOK $SYSDIR\LabJackUD.dll
    ${If} ${RunningX64}
        ${DisableX64FSRedirection}
        Delete /REBOOTOK $SYSDIR\LabJackUD.dll
        ${EnableX64FSRedirection}
    ${EndIf}
SectionEnd


Section -un.labjack_driver_ud_dotnet
    Delete /REBOOTOK $INSTDIR\Drivers\LJUDDotNet.dll
    DeleteRegKey /IfEmpty HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\.NETFramework\AssemblyFolders\LJUDDotNet"
    DeleteRegKey /IfEmpty HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\.NETFramework\v2.0.50727\AssemblyFoldersEx\LJUDDotNet"
SectionEnd

