# LabJack Windows Example Installer

Deploy your code in a single installer alongside its [LabJack](https://labjack.com/) dependencies.

We've done the hard parts, so to get started you'll [add your files](#add-your-files) to a LabJack-based [NSIS installer](http://nsis.sourceforge.net/Docs/Chapter1.html#). From there, you can [re-brand](#re-brand-your-installer) and [prepare your installer](#preparing-your-installer-for-distribution) for distribution.




## Advantages

- Get up and running quickly by following LabJack's example
- [Distribute](#youre-done) one installer: make it simple for your users
- Customize and [re-brand](#re-brand-your-installer) your installer
- Receive [modular updates](#modular-updates) from LabJack at your own pace
- Create a [custom install](#updating-files-to-be-installed) so you can rely on specific LabJack file versions
- [Minimal install](#remove-unneeded-labjack-sections): get rid of the files you don't need




## Alternatives

If you have LabJack dependencies and you already have an installer already (or if you don't want to use NSIS), you have other options:

___Call The LabJack Basic Installer___

Call the [LabJack Basic Installer](https://labjack.com/support/software/installers/ud/archive/ud-setup-basic) silently from your own installer.

This is convenient, but the public LabJack installer file versions may conflict with the LabJack file versions your code relies on. If your code does depend on very specific LabJack file versions, read on.

___Manually Install LabJack Files___

Manually installing LabJack files allows you to put LabJack files wherever you need them to keep them from conflicting with the public LabJack installer file versions. You can use the .nsi scripts in `installer_src/labjack/` to figure out what LabJack files are needed.




## What You'll Need

- A [code signing certificate](#sign-your-installer) - note that this can take a week or so to be approved.
- LabJack files, which can be downloaded from [https://s3.amazonaws.com/lj-amalg-win/latest/Files.zip](https://s3.amazonaws.com/lj-amalg-win/latest/Files.zip)
- A working knowledge of NSIS. (Don't worry - you can follow LabJack's example and the [NSIS documentation](http://nsis.sourceforge.net/Docs/Contents.html) is concise.)




## Introduction

The unmodified lj_amalg.nsi does a couple of things. Briefly:

- Declares necessary installer variables / macros
- Uses [NSIS Modern User Interface](http://nsis.sourceforge.net/Docs/Modern%20UI/Readme.html)
- Installs "LabJack Installer Sections"
    - These sections install files and write Windows registry values
- Provides placeholder installation and uninstallation sections in `installer_src\custom\my_section.nsi` for your files
- Sets up "LabJack Uninstaller Sections"
    - These do the opposite of their corresponding installer sections
- Upon installer initialization, checks for an existing installation (see `Function .onInit`)
    - If an appropriate uninstaller is in the Windows registry, runs the uninstaller
    - If files continue to exist after the uninstaller runs, prompts the user to manually remove the files and aborts installation. (Future versions may automatically fix this.)




## Re-brand Your Installer

Let's start with re-branding your installer. This changes the installer name, icon, website, etc. More importantly, it sets the [`InstallDir` path](http://nsis.sourceforge.net/Docs/Chapter4.html#ainstalldir) to install to a custom location.

To re-brand your installer as your own, search lj_amalg.nsi for the string `changeme`. Among the things you'll need to change:

- The [`Name` command](http://nsis.sourceforge.net/Docs/Chapter4.html#aname)
- Change the Icon:
    - Change the [`Icon` path](http://nsis.sourceforge.net/Docs/Chapter4.html#aicon)
    - Change the `UninstallIcon` path
- Change the file name passed to the [`OutFile` command](http://nsis.sourceforge.net/Docs/Chapter4.html#aoutfile)
- `!define COMPANY`
- `!define URL`




## Add Your Files

First, put your files to be installed into the `Files` directory.

Next, edit `installer_src\custom\my_section.nsi` to tell NSIS where files are on your machine (where you just put them) and where you want files to be installed.

The path for each `File` command must be given relative to .nsi script that uses `!include` to include `my_section.nsi` - the directory containing this `readme.md` and `lj_amalg.nsi`. Also, make sure you set the path using the [`SetOutPath` command](http://nsis.sourceforge.net/Docs/Chapter4.html#setoutpath).




## Write Your Uninstaller Section

Edit the section in `installer_src\custom\my_section.nsi` named `-un.my_section`. You only need to remove the custom files you install.




## Sections

`!include` pulls in a `.nsi` file as if it was written directly in the including file itself. This means:

- the order of the sections is set by the `!include` order
- the file paths passed to the [`File` command](http://nsis.sourceforge.net/Docs/Chapter4.html#file) should be relative to the including file (or absolute)



### LabJack Sections

LabJack sections are `!include`d in a modular format. There are two levels (driver and app) and two stacks: LJM and UD. (LJM is for T-series devices and Digits; UD is for U3 / U6 / and UE9.) LJM and UD both share some files dependencies, so if you need either a LJM or UD section, then you should leave the `shared` section, as well. Note that if you remove a driver section for a given stack, apps for that stack will not be able to run; e.g. if you remove the `driver_ud.nsi`, then `app_ud.nsi` should be removed as well.

Also note that each LabJack install section has a corresponding uninstall section that begins with `un_`. For example, `driver_ud.nsi`'s uninstall section is `un_driver_ud.nsi`.

The `driver_ljm.nsi` section uses the [NSIS AccessControl Plugin](http://nsis.sourceforge.net/AccessControl_plug-in), which is included in `nsis_plugins` via `!addplugindir`.



### Remove Unneeded LabJack Sections

You can remove unneeded LabJack sections to reduce your installer size.

To remove LabJack sections, edit `lj_amalg.nsi` to remove the `!include` statements that include unwanted LabJack sections. For example, if your users won't need to use LabJack graphical applications, remove the `!include` statements that include `app` .nsi scripts. Don't forget to remove the uninstall sections, as well!




## Preparing Your Installer For Distribution

Once you're ready to prepare your installer for distribution you'll need to compile, sign, and test your installer.

It's not hard. Read on!



### Compile Your Installer

To [compile](http://nsis.sourceforge.net/Docs/Chapter2.html#tutcompiler), use [MakeNSIS](http://nsis.sourceforge.net/Docs/Chapter3.html#usage).

For example:
`makensis.exe /P2 lj_amalg.nsi`



### Sign Your Installer

To sign your installer, you'll need to get a SHA256 code signing certificate from a trusted Certificate Authority (CA). Wikipedia has a pretty good introduction if you'd like to know more about [code signing](https://en.wikipedia.org/wiki/Code_signing). Note that it may take a while for a CA to issue you a certificate, so get the process started before you need it. Also, note that if you'll need a SHA1 certificate for dual-signing in order to [support Windows XP and Vista](http://support.ksoftware.net/support/solutions/articles/215805-the-truth-about-sha1-sha-256-and-code-signing-certificates-).

Once you have your SHA256 code signing certificate, you'll need to [convert it into a .pfx](https://support.godaddy.com/help/article/2698/installing-a-code-signing-certificate-in-windows) file. There are a few different formats your CA may distribute the certificate to you, so follow the instructions below that match. Note that if you want to dual-sign, you'll need a .pfx for both your SHA1 and your SHA256 certificates.

​___.pem and .key to .pfx___

```
openssl pkcs12 -inkey my_key.key -in my_cert.pem -export -out my_cert.pfx   
```

​​___.key (or .pvk) and .spc to .pfx___

Convert the .key to .pvk:

```
pvk.exe -in my_key.key -strong -topvk -out my_key.pvk   
```

Then, export .spc and .pvk to .pfx:
```
pvkimprt -PFX my_cert.spc my_key.pvk
```

In the wizard that pops up:

- You should export your private key (you're exporting it to the .pfx file you're creating)
- The "Export File Format" should be "Personal Information Exchange - PKCS #12 (.PFX)" and:
    - You should include all certificates in the certification path
    - You should export all extended properties

If you get stuck, GoDaddy has a good article on [code signing and .pfx creation](https://support.godaddy.com/help/article/2698/installing-a-code-signing-certificate-in-windows).

With your .pfx, sign your installer. For dual-signing, you'll sign your installer with both a SHA256 and a SHA1 certificate. For example, you can use [SignTool](https://msdn.microsoft.com/en-us/library/windows/desktop/aa387764(v=vs.85).aspx) to dual-sign:

```
signtool.exe sign ^
  /t http://tsa.starfieldtech.com/ ^
  /d "Awesome Installer" ^
  /du https://example.com ^
  /p mypassword ^
  /f my_sha1.pfx ^
  /v AwesomeInstaller.exe

signtool.exe sign ^
  /fd sha256 ^
  /tr http://tsa.starfieldtech.com/ ^
  /td sha256 ^
  /as ^
  /d "Awesome Installer" ^
  /du https://example.com ^
  /p mypassword ^
  /f my_sha2.pfx ^
  /v AwesomeInstaller.exe
```

If you don't need to dual-sign, just use SignTool as above to sign with your SHA256 .pfx, but without the `/as` option.

Following signing, you'll want to verify the signature. For example, to verify a dual-signed .exe:
```
signtool.exe verify /ds 0 /hash SHA1 /pa AwesomeInstaller.exe
signtool.exe verify /ds 1 /hash SHA256 /pa AwesomeInstaller.exe
```



### Test

Finally, you'll need to test your installer. You'll want to:

- Make sure files install correctly on all the versions of Windows that you support (XP in particular has some complexities)
- Make sure files uninstall correctly
- Beware of [`Delete /REBOOTOK`](http://nsis.sourceforge.net/Docs/Chapter4.html#delete) causing problems: When you run the installer, then run the installer again, then reboot, make sure all files are as they should be. Also, you can check the uninstaller log output for "Delete on reboot" (you can right click on the log and copy all the log output).




## You're Done

![NSISWizard](http://files.labjack.com/images/lj_amalg_inst/nsis_wizard.jpg "Besides being a pinball wizard, Tommy is a talented NSIS programmer.")

Now you're an NSIS wizard - there's no twist! Now you can distribute your installer to happy users. All that's left is updating your installer.




## Modular Updates

When updating, you need to update the files to be installed and the installer itself.



### Updating Files To Be Installed

Currently, LabJack distributes this as a binary .zip file. Download it from here:

[https://s3.amazonaws.com/lj-amalg-win/latest/Files.zip](https://s3.amazonaws.com/lj-amalg-win/latest/Files.zip)

Or, install a version of LabJack's file's using the public LabJack installer, then copy the specific files from where they are installed into this directory's `File\` directory.


___Custom LabJack File Versions___

Are you dependent on particular versions of LabJack files? In this case, if a user runs the public LabJack installer (for example, if they need particular versions of LabJack files) it may break your application.

To solve this, you should install custom LabJack file versions:

- You need to change the names of the LabJack files in your installer that are installed to `$SYSDIR`. For example, add a prefix - e.g. `LabJackM.dll` becomes `myapp_LabJackM.dll`.
- You need to make sure your deployed code (if any) uses the LabJack files in your `$INSTDIR` directory rather than LabJack's `$INSTDIR` directory ([LabJack's LJM documentation](https://labjack.com/support/software/api/ljm/what-ljm-files-are-installed) shows the probable `$INSTDIR` locations for LJM files on Windows, which is the same for UD files).
- If using LJM: the default LJM constants file (`$APPDATA\LabJack\LJM\ljm_constants.json`) is hardcoded in LJM:
    - You need to edit `driver_ljm.nsi` to change the install location to a custom location instead of `$APPDATA\LabJack`
    - You need to use the [`LJM_WriteLibraryConfigStringS` function](https://labjack.com/support/software/api/ljm/function-reference/LJMWriteLibraryConfigStringS) during your application's initialization to set the [`LJM_CONSTANTS_FILE` parameter](https://labjack.com/support/software/api/ljm/constants/ljmconstantsfile) to your custom location

For whatever files you add a custom prefix to, make sure you find all instances of the file name in all files.





### Updating The Installer Itself

Receive modular updates from LabJack by cloning this repository. Then, pull in updates when you're ready.

If you don't have lots of changes, it should be easy to merge your working branch with LabJack's origin master branch.

If you have lots of changes, you may simply want use the git history of LabJack's origin master branch to manually update your installer as needed. (Also, give us [Feedback](#feedback) if it gets frustrating or if you have a better way.)




## Known Issues

- The uninstaller does not delete itself when run as part of the installer (from within `Function .onInit`). This is generally not a problem because the installer will be executed immediately after (unless the user aborts installation).




## Feedback

If you're using this, please let us know how it's working for you. We will try to make it better for you (if you let us know how) because we want you to succeed!



