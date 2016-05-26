; LabJack driver files for LJM
;
; Prerequisites:
;  - $INSDIR must be set
;  - `!include labjack\driver_shared.nsi` must happen before this is `!include`d

Section -labjack_driver_ljm_base
    SetShellVarContext "all"
    SetOverwrite on

    SetOutPath $INSTDIR\Drivers
    File Files\32-bit\LabJackM.h
    File Files\32-bit\LabJackM.lib

    SetOutPath $INSTDIR\Drivers\64bit
    File Files\64-bit\LabJackM.lib

    SetOutPath $SYSDIR
    File Files\32-bit\LabJackM.dll

    ${If} ${RunningX64}
        ${DisableX64FSRedirection}
        SetOutPath $SYSDIR
        File Files\64-bit\LabJackM.dll
        ${EnableX64FSRedirection}
    ${EndIf}
SectionEnd


Section -labjack_driver_ljm_dotnet
    SetShellVarContext "all"
    SetOverwrite on

    SetOutPath $INSTDIR\Drivers
    File Files\32-bit\LabJack.LJM.dll
    WriteRegStr HKLM "SOFTWARE\Microsoft\.NETFramework\AssemblyFolders\LabJack.LJM" "" "$INSTDIR\Drivers"
    WriteRegStr HKLM "SOFTWARE\Microsoft\.NETFramework\v2.0.50727\AssemblyFoldersEx\LabJack.LJM" "" "$INSTDIR\Drivers"

    ExecWait '$INSTDIR\Drivers\InstallLJNET.exe "$INSTDIR\Drivers\LabJack.LJM.dll"'
SectionEnd


Section -labjack_driver_ljm_data
    # For $APPDATA, SetShellVarContext needs to be "all"
    SetShellVarContext "all"

    SetOverwrite on

    SetOutPath "$APPDATA\LabJack"
    Delete "$APPDATA\LabJack\LJM\readme_ljm_special_addressess.md" ; Sic
    File /r Files\LabJack\*

    SetOverwrite off
        SetOutPath "$APPDATA\LabJack\LJM"

        IfFileExists \
            "$APPDATA\LabJack\LJM\ljm_special_addresses.config" \
            spec_addr_exist
        ; spec_addr_noexist:
            Goto spec_addr_end
        spec_addr_exist:
            Rename \
                "$APPDATA\LabJack\LJM\ljm_special_addresses.config" \
                "$APPDATA\LabJack\LJM\ljm_specific_ips.config"
        spec_addr_end:

        File Files\32-bit\ljm_specific_ips.config

        AccessControl::GrantOnFile "$APPDATA\LabJack\LJM" "(S-1-5-32-545)" "FullAccess"
        AccessControl::GrantOnFile "$APPDATA\LabJack\LJM\*" "(S-1-5-32-545)" "FullAccess"
    SetOverwrite on
SectionEnd

