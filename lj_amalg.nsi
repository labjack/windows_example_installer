Name LabJack # Changeme to re-brand!

SetCompressor lzma

RequestExecutionLevel admin

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 0.90

!define COMPANY LabJack # Changeme to re-brand!
!define URL https://labjack.com # Changeme to re-brand!

# MUI Symbol Definitions
!define MUI_ICON "icons\LabJackIcon.ico" # Changeme to re-brand!
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER LabJack # Changeme to re-brand!
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\win-uninstall.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include Sections.nsh
!include MUI2.nsh
!include "DotNetVer.nsh"

# Reserved Files
ReserveFile "${NSISDIR}\Plugins\System.dll"

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile LabJack.exe # Changeme to re-brand!
InstallDir $PROGRAMFILES\LabJack # Changeme to re-brand!
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion ${VERSION}.0.0
VIAddVersionKey ProductName LabJack # Changeme to re-brand!
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright "LabJack Corporation 2016" # Changeme to re-brand!
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
# Macro for creating a registry key
!define HKEY_CLASSES_ROOT 0x80000000
!define HKEY_CURRENT_USER 0x80000001
!define HKEY_LOCAL_MACHINE 0x80000002
!define HKEY_USERS 0x80000003
!define HKEY_PERFORMANCE_DATA 0x80000004
!define HKEY_CURRENT_CONFIG 0x80000005
!define HKEY_DYN_DATA 0x80000006
!define KEY_CREATE_SUB_KEY 0x0004

!include "LogicLib.nsh"
!include "x64.nsh"
!include "winver.nsh"

!include "installer_src\utility\SMGroupShortcut.nsi"
!include "installer_src\utility\macros.nsi"

!addplugindir "nsis_plugins"

##
# LabJack Installer Sections
##
!include "installer_src\labjack\driver_shared.nsi"
!include "installer_src\labjack\driver_ud.nsi"
!include "installer_src\labjack\driver_ljm.nsi"

SectionGroup "LabJack Applications" SEC0001
    !include "installer_src\labjack\app_shared.nsi"
    !include "installer_src\labjack\app_ud.nsi"
    !include "installer_src\labjack\app_ljm.nsi"
SectionGroupEnd

!include "installer_src\common\uninstaller.nsi"


##
# Add your custom files to this and uncomment:
##
# !include "installer_src\custom\my_section.nsi"



##
# LabJack Uninstaller Sections
##
!include "installer_src\labjack\un_app_ljm.nsi"
!include "installer_src\labjack\un_app_ud.nsi"
!include "installer_src\labjack\un_app_shared.nsi"

!include "installer_src\labjack\un_driver_ljm.nsi"
!include "installer_src\labjack\un_driver_ud.nsi"
!include "installer_src\labjack\un_driver_shared.nsi"

!include "installer_src\common\un_uninstaller.nsi"



Function .onInit
    # Prevent multiple instances of this installer
    System::Call 'kernel32::CreateMutex(p 0, i 0, t "$(^Name)_installer") p .r1 ?e'
    Pop $R0
    StrCmp $R0 0 +3
        MessageBox MB_OK|MB_ICONEXCLAMATION "The installer is already running."
        Abort

    # We require XP and greater
    ${If} ${AtLeastWinXP}
    DetailPrint "WindowsXP or higher detected"
    ${Else}
        MessageBox mb_iconstop "This installer requires at least WindowsXP"
        SetErrorLevel 2
        Quit
    ${EndIf}

    # We require Administrator rights
    ${If} ${IsWinXP}
    DetailPrint "WindowsXP detected"
    ${Else}
        UserInfo::GetAccountType
        pop $0
        ${If} $0 != "admin" # Require admin rights on NT4+
                MessageBox mb_iconstop "Administrator rights required!"
                SetErrorLevel 740 # ERROR_ELEVATION_REQUIRED
                Quit
        ${EndIf}
    ${EndIf}

    # Check the registry for this installer's uninstaller and run it
    ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString
    StrCmp $R0 "" done
        MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
            "An older version of this software is already installed. $\n$\nClick `OK` to remove the \
            previous version or `Cancel` to cancel this upgrade." \
            IDOK uninst
        Abort

    uninst:
        # Run the uninstaller
        ClearErrors
        ExecWait '$R0 _?=$INSTDIR' # Do not copy the uninstaller to a temp file
        SetRebootFlag false

        IfErrors no_remove_uninstaller done
        # You can either use Delete /REBOOTOK in the uninstaller or add some 
        # code here to remove the uninstaller. Use a registry key to check
        # whether the user has chosen to uninstall. If you are using an 
        # uninstaller components page, make sure all sections are uninstalled.
        no_remove_uninstaller:
        MessageBox \
            mb_iconstop \
            "Error uninstalling previous version.  Please run the uninstaller manually."
        SetErrorLevel 2
        Quit
    done:

    # Make sure the installer worked
    InitPluginsDir
    GetDLLVersion "$SYSDIR\LabJackUD.dll" $R0 $R1
    IntOp $R2 $R0 >> 16
    IntOp $R2 $R2 & 0x0000FFFF # $R2 now contains major version
    IntOp $R3 $R0 & 0x0000FFFF # $R3 now contains minor version
    IntOp $R4 $R1 >> 16
    IntOp $R4 $R4 & 0x0000FFFF # $R4 now contains release
    IntOp $R5 $R1 & 0x0000FFFF # $R5 now contains build
    StrCpy $0 "$R2.$R3.$R4.$R5" # $0 now contains a version string like "1.2.0.192"
    ${If} $0 != "0.0.0.0" # Require admin rights on NT4+
        MessageBox \
            mb_iconstop \
            "You must first uninstall the current LabJackUD version before using this installer.  If that step has already been completed, please check for and delete C:\Windows\System32\LabJackUD.dll C:\Windows\SysWOW64\LabJackUD.dll"
        SetErrorLevel 2 # ERROR_ELEVATION_REQUIRED
        Quit
    ${EndIf}

    GetDLLVersion "$SYSDIR\LabJackM.dll" $R0 $R1
    IntOp $R2 $R0 >> 16
    IntOp $R2 $R2 & 0x0000FFFF # $R2 now contains major version
    IntOp $R3 $R0 & 0x0000FFFF # $R3 now contains minor version
    IntOp $R4 $R1 >> 16
    IntOp $R4 $R4 & 0x0000FFFF # $R4 now contains release
    IntOp $R5 $R1 & 0x0000FFFF # $R5 now contains build
    StrCpy $0 "$R2.$R3.$R4.$R5" # $0 now contains a version string like "1.2.0.192"
    ${If} $0 != "0.0.0.0" # Require admin rights on NT4+
        MessageBox \
            mb_iconstop \
            "You must first uninstall the current LabJackM version using this installer.  If that step has already been completed, please check for and delete C:\Windows\System32\LabJackM.dll C:\Windows\SysWOW64\LabJackM.dll"
        SetErrorLevel 2 # ERROR_ELEVATION_REQUIRED
        Quit
    ${EndIf}

    ${If} ${HasDotNet2.0}
        DetailPrint "Microsoft .NET Framework 2.0 installed."
    ${Else}
        MessageBox \
            MB_YESNO \
            ".NET 2.0 (or later) must be installed to use applications included in this installer.  Would you like to install it now?" \
            IDNO \
            NoNet
        SetOutPath "$TEMP\$(^Name)"
        File Files\32-bit\dotnetfx35setup.exe
        Exec "$TEMP\$(^Name)\dotnetfx35setup.exe"
        # SetErrorLevel 2 # ERROR_ELEVATION_REQUIRED
        NoNet:
        Quit
    ${EndIf}
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
FunctionEnd

# Section Descriptions
!include "installer_src\section_descriptions.nsi"
