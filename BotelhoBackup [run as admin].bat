@title BotelhoBackup: Backup, Migration and Folder Cloning script
@echo off
openfiles > NUL 2>&1
if NOT %ERRORLEVEL% EQU 0 goto :NotAdmin
echo. ----------------------------------------------------------------------
echo. Welcome to BotelhoBackup: Backup, Migration and Folder Cloning script!
echo. See https://github.com/ABotelho23/BotelhoBackup for more information
echo. Created by Alex Botelho with the help of Aaron Langlois and Thomas Belway
echo. ----------------------------------------------------------------------
goto :mainmenu
:NotAdmin
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. PLEASE RUN AS ADMIN! Right-click script and click "Run as administrator" Closing in 10 seconds.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 10
GOTO :realend

:mainmenu
echo. ======================================================================
echo. + + + + + + + + + + + + + + + MAIN MENU + + + + + + + + + + + + + + +
echo. ======================================================================
echo. 1. Backup Data
echo. Used for standard User folders backup when unit can boot.
echo. ----------------------------------------------------------------------
echo. 2. Migrate Data [experimental]
echo. Used to migrate a User folders backup created by this
echo. script back unto the newly setup unit's User folders.
echo. ----------------------------------------------------------------------
echo. 3. Migrate Directly from an Old PC's HDD [experimental]
echo. Used for when the old PC does not boot,
echo. and its HDD is docked to the new PC.
echo. ----------------------------------------------------------------------
echo. 4. Clone folders [experimental]
echo. Simply clones the contents of two folders.
echo. Do NOT use to migrate User folders; this option does not have exclusions
echo. for files not meant to be migrated.
echo. ----------------------------------------------------------------------
echo. 5. Backup Data (CUSTOM) [experimental]
echo. Used for backing up a PC's User folders when the PC doesn't boot.
echo. An external HDD is also required for this option.
echo. ----------------------------------------------------------------------
echo. What would you like to do?
set /P backMigSel=(Enter 1-5 or 'q'/'Q' to quit)

IF "%backMigSel%"=="1" GOTO :backup
IF "%backMigSel%"=="2" GOTO :migration
IF "%backMigSel%"=="3" GOTO :migrateoldpc
IF "%backMigSel%"=="4" GOTO :clonefolders
IF "%backMigSel%"=="5" GOTO :custombackup
IF "%backMigSel%"=="q" GOTO :quit
IF "%backMigSel%"=="Q" GOTO :quit

echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. That is not a valid selection, returning to main menu.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :mainmenu

:backup
set /P backDestLet=What is the drive letter of the drive to put the backup unto?
IF "%backDestLet%"=="c" GOTO :cantusecback
IF "%backDestLet%"=="C" GOTO :cantusecback
IF NOT EXIST "%backDestLet%:\" GOTO :invalidletterback

IF NOT EXIST "C:\Users" GOTO :xpBackup

echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Valid selection. Starting Backup from C:\Users to "%backDestLet%:\BotelhoBackup\Users" in 10 seconds.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 10
echo. STARTING BACKUP NOW!

mkdir "%backDestLet%:\BotelhoBackup"
mkdir "%backDestLet%:\BotelhoBackup\Backup"
mkdir "%backDestLet%:\BotelhoBackup\Backup\Users"
robocopy "C:\Users" "%backDestLet%:\BotelhoBackup\Backup\Users" /v /log+:"%backDestLet%:\BotelhoBackup\backupLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "NTUSER.DAT" /xf "NTUSER.DAT*" /xf "NTUSER.DAT.*" /xf "NETUSER.DAT" /xf "NETUSER.DAT*" /xf "dat.*" /xf "desktop.ini" /xd "OneDrive" /xd "Local Settings" /xd "AppData" /xd "Application Data" /xd "C:\Users\All Users" /xd "C:\Users\Default User" /xd "C:\Users\Default" /xd "C:\Users\DefaultAppPool" /xd "C:\Users\Default.migrated"
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. BACKUP COMPLETE. Please verify. Displaying log file.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
start "" "%backDestLet%:\BotelhoBackup\backupLog.txt"
GOTO :end

:xpBackup
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Valid selection. XP Installation detected. Starting Backup from C:\Documents and Settings to "%backDestLet%:\BotelhoBackup\Users" in 10 seconds.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 10
echo. STARTING XP BACKUP NOW!

mkdir "%backDestLet%:\BotelhoBackup"
mkdir "%backDestLet%:\BotelhoBackup\Backup"
mkdir "%backDestLet%:\BotelhoBackup\Backup\Users"
robocopy "C:\Documents and Settings" "%backDestLet%:\BotelhoBackup\Backup\Users" /v /log+:"%backDestLet%:\BotelhoBackup\backupLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "NTUSER.DAT" /xf "NTUSER.DAT*" /xf "NTUSER.DAT.*" /xf "NETUSER.DAT" /xf "NETUSER.DAT*" /xf "dat.*" /xf "desktop.ini" /xd "OneDrive" /xd "Local Settings" /xd "AppData" /xd "Application Data" /xd "C:\Documents and Settings\All Users" /xd "C:\Documents and Settings\Default User" /xd "C:\Documents and Settings\Default" /xd "C:\Documents and Settings\DefaultAppPool" /xd "C:\Documents and Settings\Default.migrated"
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. BACKUP COMPLETE. Please verify. Displaying log file.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
start "" "%backDestLet%:\BotelhoBackup\backupLog.txt"
GOTO :end

:migration
set /P migSrcLet=What is the drive letter of the drive to migrate from?
IF "%migSrcLet%"=="c" GOTO :cantusecmig
IF "%migSrcLet%"=="C" GOTO :cantusecmig
IF NOT EXIST "%migSrcLet%:\" GOTO :invalidlettermig
IF NOT EXIST "%migSrcLet%:\BotelhoBackup" GOTO :nobackupfound

echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Valid selection. Starting Migration from "%migSrcLet%:\BotelhoBackup\Backup\Users" to "C:\Users" in 10 seconds.
echo. Note: Migration is done to Users folder; if old user folder name is different from new user, unexpected results may occur.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 10
echo. STARTING MIGRATION NOW!

robocopy "%migSrcLet%:\BotelhoBackup\Backup\Users" "C:\Users" /v /log+:"C:\Users\migrationLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xf "desktop.ini"
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. MIGRATION COMPLETE. Displaying log file.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
start "" "C:\Users\migrationLog.txt"
GOTO :end

:migrateoldpc
set /P oldSrcLet=What is the drive letter of the old drive connected as?
IF "%oldSrcLet%"=="c" GOTO :cantusecold
IF "%oldSrcLet%"=="C" GOTO :cantusecold
IF NOT EXIST "%oldSrcLet%:\" GOTO :invalidletterold
IF NOT EXIST "%oldSrcLet%:\Users" GOTO :notoldhdd

IF NOT EXIST "%oldSrcLet%:\Users" GOTO :xpmigrateoldpc

echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Valid selection. Starting Migration from old PC "%oldSrcLet%:\Users" to "C:\Users" in 10 seconds.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 10
echo. STARTING MIGRATION FROM OLD PC NOW!

robocopy "%oldSrcLet%:\Users" "C:\Users" /v /log+:"C:\Users\migrationOldPCLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "NTUSER.DAT" /xf "NTUSER.DAT*" /xf "NTUSER.DAT.*" /xf "NETUSER.DAT" /xf "NETUSER.DAT*" /xf "dat.*" /xf "desktop.ini" /xd "OneDrive" /xd "Local Settings" /xd "AppData" /xd "Application Data" /xd "%oldSrcLet%:\Users\All Users" /xd "%oldSrcLet%:\Users\Default User" /xd "%oldSrcLet%:\Users\Default" /xd "%oldSrcLet%:\Users\DefaultAppPool" /xd "%oldSrcLet%:\Users\Default.migrated"
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. MIGRATION FROM OLD PC COMPLETE. Please verify. Displaying log file.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
start "" "C:\Users\migrationOldPCLog.txt"
GOTO :end

:xpmigrateoldpc
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Valid selection. XP Installation Detected. Starting Migration from old PC "%oldSrcLet%:\Documents and Settings" to "C:\Users" in 10 seconds.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 10
echo. STARTING XP MIGRATION FROM OLD PC NOW!

robocopy "%oldSrcLet%:\Documents and Settings" "C:\Users" /v /log+:"C:\Users\migrationOldPCLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "NTUSER.DAT" /xf "NTUSER.DAT*" /xf "NTUSER.DAT.*" /xf "NETUSER.DAT" /xf "NETUSER.DAT*" /xf "dat.*" /xf "desktop.ini" /xd "OneDrive" /xd "Local Settings" /xd "AppData" /xd "Application Data" /xd "%oldSrcLet%:\Documents and Settings\All Users" /xd "%oldSrcLet%:\Documents and Settings\Default User" /xd "%oldSrcLet%:\Documents and Settings\Default" /xd "%oldSrcLet%:\Documents and Settings\DefaultAppPool" /xd "%oldSrcLet%:\Documents and Settings\Default.migrated"
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. MIGRATION FROM OLD PC COMPLETE. Please verify. Displaying log file.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
start "" "C:\Users\migrationOldPCLog.txt"
GOTO :end

:clonefolders
:inputCloneSrc
set /P cloneSrc=What is the source folder? Please include drive letter in path as well as the colon, and use backslashes.
IF NOT EXIST "%cloneSrc%" GOTO :cloneSrcNotExist

:inputCloneDes
set /P cloneDes=What is the destination folder? Please include drive letter in path as well as the colon, and use backslashes. Do not include last backslash.
IF NOT EXIST "%cloneDes%" GOTO :cloneDesNotExist

echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Valid selections. Starting Cloning of "%cloneSrc%" to "%cloneDes%" in 10 seconds.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 10
echo. STARTING CLONING NOW!

robocopy "%cloneSrc%" "%cloneDes%" /v /log+:"%cloneDes%\cloneLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "desktop.ini"
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. CLONING COMPLETE. Please verify. Displaying log file.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
start "" "%cloneDes%\cloneLog.txt"
GOTO :end

:custombackup

:customInputSrc
set /P customSrc=What is the drive letter of the drive to backup?
IF "%customSrc%"=="c" GOTO :customcantusecbackSrc
IF "%customSrc%"=="C" GOTO :customcantusecbackSrc
IF NOT EXIST "%customSrc%:\" GOTO :custominvalidletterbackSrc

:customInputDes
set /P customDes=What is the drive letter of the drive to put the backup unto?
IF "%customDes%"=="c" GOTO :customcantusecbackDes
IF "%customDes%"=="C" GOTO :customcantusecbackDes
IF NOT EXIST "%customDes%:\" GOTO :custominvalidletterbackDes

IF NOT EXIST "%customSrc%:\Users" GOTO :xpcustombackup

echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Valid selection. Starting Custom Backup from %customSrc%:\Users to "%customDes%:\BotelhoBackup\Users" in 10 seconds.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 10
echo. STARTING CUSTOM BACKUP NOW!

mkdir "%customDes%:\BotelhoBackup"
mkdir "%customDes%:\BotelhoBackup\Backup"
mkdir "%customDes%:\BotelhoBackup\Backup\Users"
robocopy "%customSrc%:\Users" "%customDes%:\BotelhoBackup\Backup\Users" /v /log+:"%customDes%:\BotelhoBackup\backupLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "NTUSER.DAT" /xf "NTUSER.DAT*" /xf "NTUSER.DAT.*" /xf "NETUSER.DAT" /xf "NETUSER.DAT*" /xf "dat.*" /xf "desktop.ini" /xd "OneDrive" /xd "Local Settings" /xd "AppData" /xd "Application Data" /xd "%customSrc%:\Users\All Users" /xd "%customSrc%:\Users\Default User" /xd "%customSrc%:\Users\Default" /xd "%customSrc%:\Users\DefaultAppPool" /xd "%customSrc%:\Users\Default.migrated"
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. CUSTOM BACKUP COMPLETE. Please verify. Displaying log file.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
start "" "%customDes%:\BotelhoBackup\backupLog.txt"
GOTO :end

:xpcustombackup
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Valid selection. XP Installation detected. Starting Custom Backup from %customSrc%:\Documents and Settings to "%customDes%:\BotelhoBackup\Users" in 10 seconds.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 10
echo. STARTING XP CUSTOM BACKUP NOW!

mkdir "%customDes%:\BotelhoBackup"
mkdir "%customDes%:\BotelhoBackup\Backup"
mkdir "%customDes%:\BotelhoBackup\Backup\Users"
robocopy "%customSrc%:\Documents and Settings" "%customDes%:\BotelhoBackup\Backup\Users" /v /log+:"%customDes%:\BotelhoBackup\backupLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "NTUSER.DAT" /xf "NTUSER.DAT*" /xf "NTUSER.DAT.*" /xf "NETUSER.DAT" /xf "NETUSER.DAT*" /xf "dat.*" /xf "desktop.ini" /xd "OneDrive" /xd "Local Settings" /xd "AppData" /xd "Application Data" /xd "%customSrc%:\Documents and Settings\All Users" /xd "%customSrc%:\Documents and Settings\Default User" /xd "%customSrc%:\Documents and Settings\Default" /xd "%customSrc%:\Documents and Settings\DefaultAppPool" /xd "%customSrc%:\Documents and Settings\Default.migrated"
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. CUSTOM XP BACKUP COMPLETE. Please verify. Displaying log file.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
start "" "%customDes%:\BotelhoBackup\backupLog.txt"
GOTO :end

:cantusecback
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. C: drive cannot be used as a destination, please select another drive
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :backup

:invalidletterback
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. A drive with that letter is not connected. Please check the letter and try again.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :backup

:cantusecmig
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. C: drive cannot be used as a source, please select another drive
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :migration

:invalidlettermig
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. A drive with that letter is not connected. Please check the letter and try again.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :migration

:nobackupfound
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Botelho-made backup not found on the selected drive. Please try again.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :migration

:cantusecold
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. C: drive cannot be used as a source, please select another drive
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :migrateoldpc

:invalidletterold
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. A drive with that letter is not connected. Please check the letter and try again.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :migrateoldpc

:notoldpc
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. This drive doesn't look like an old PC's drive. Please try again.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :migrateoldpc

:cloneSrcNotExist
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Can't find this source folder. Please double check and try again.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :inputCloneSrc

:cloneDesNotExist
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Can't find this destination folder. Please double check and try again.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :inputCloneDes

:customcantusecbackSrc
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. C: drive cannot be used as a source for custom migrations, please select another drive (the drive should be an internal HDD docked).
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :customInputSrc

:custominvalidletterbackSrc
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. A drive with that letter is not connected. Please check the letter and try again.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :customInputSrc

:customcantusecbackDes
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. C: drive cannot be used as a destination for custom migrations, please select another drive (the drive should be an external HDD).
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :customInputDes

:custominvalidletterbackDes
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. A drive with that letter is not connected. Please check the letter and try again.
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :customInputDes

:quit
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
echo. Quitting...
echo. + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
TIMEOUT 3
@cls
GOTO :realend

:end
pause
:realend
