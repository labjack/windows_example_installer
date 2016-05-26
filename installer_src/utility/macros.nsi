; Common macros

!macro CreateRegKey ROOT_KEY SUB_KEY
    Push $0
    Push $1
    System::Call \
        /NOUNLOAD \
        "Advapi32::RegCreateKeyExA(i, t, i, t, i, i, i, *i, i) i(${ROOT_KEY}, '${SUB_KEY}', 0, '', 0, ${KEY_CREATE_SUB_KEY}, 0, .r0, 0) .r1"
    StrCmp $1 0 +2
    SetErrors
    StrCmp $0 0 +2
    System::Call /NOUNLOAD "Advapi32::RegCloseKey(i) i(r0) .r1"
    System::Free 0
    Pop $1
    Pop $0
!macroend

!macro CREATE_SMGROUP_SHORTCUT NAME PATH
    Push "${NAME}"
    Push "${PATH}"
    Call CreateSMGroupShortcut
!macroend

# Uninstaller sections
!macro DELETE_SMGROUP_SHORTCUT NAME
    Push "${NAME}"
    Call un.DeleteSMGroupShortcut
!macroend

