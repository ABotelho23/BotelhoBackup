@echo off
openfiles > NUL 2>&1
if NOT %ERRORLEVEL% EQU 0 goto :NotAdmin
echo Welcome to Staples Store #17 Tech Backup and Migrate script!
goto :mainmenu
:NotAdmin
echo PLEASE RUN AS ADMIN. Closing in 10 seconds.
TIMEOUT 10
GOTO :realend

:mainmenu
echo ----------
echo ----------
echo MAIN MENU - What would you like to do?
echo 1. Backup Data  - Used for standard User folders backup when unit can boot.
echo 2. Migrate Data [experimental/testing] - Used to migrate a User folders backup created by this script back unto the newly setup unit;s User folders.
echo 3. Migrate Directly from an Old PC's HDD [experimental/testing] - Used for when the old PC does not boot, and its HDD is docked to the new PC.
echo 4. Clone folders [NOT AVAILABLE YET]- Simply clones the contents of two folders. Do NOT use to migrate User folders; this option does not have exclusions for files not meant to be mgirated.
echo 5. Backup Data (CUSTOM) [NOT AVAILABLE YET] - Used for backing up a PC's User folders when the PC does not boot. An external HDD is also required for this option.
set /P backMigSel=What would you like to do? (Enter 1-5 or 'q'/'Q' to quit)

IF "%backMigSel%"=="1" GOTO :backup
IF "%backMigSel%"=="2" GOTO :migration
IF "%backMigSel%"=="3" GOTO :migrateoldpc
IF "%backMigSel%"=="4" GOTO :clonefolders
IF "%backMigSel%"=="5" GOTO :custombackup
IF "%backMigSel%"=="q" GOTO :quit
IF "%backMigSel%"=="Q" GOTO :quit

echo That is not a valid selection, returning to main menu.
GOTO :mainmenu

:backup
set /P backDestLet=What is the drive letter of the drive to put the backup unto?
IF "%backDestLet%"=="c" GOTO :cantusecback
IF "%backDestLet%"=="C" GOTO :cantusecback
IF NOT EXIST "%backDestLet%:\" GOTO :invalidletterback

echo Valid selection. Starting Backup from C:\Users to "%backDestLet%:\StaplesBackup\Users" in 10 seconds.
TIMEOUT 10
echo STARTING BACKUP NOW!

mkdir "%backDestLet%:\StaplesBackup"
mkdir "%backDestLet%:\StaplesBackup\Backup"
mkdir "%backDestLet%:\StaplesBackup\Backup\Users"
robocopy "C:\Users" "%backDestLet%:\StaplesBackup\Backup\Users" /v /log:"%backDestLet%:\StaplesBackup\backupLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "NETUSER.DAT" /xf "NETUSER.DAT*" /xf "netuser.dat.*" /xd "Local Settings" /xd "AppData" /xd "Application Data" /xd "C:\Users\All Users" /xd "C:\Default User" /xd "C:\Users\Default" /xd "C:\Users\DefaultAppPool" /xd "C:\Users\Default.migrated"
echo BACKUP COMPLETE. Please verify. Displaying log file.
start "" "%backDestLet%:\StaplesBackup\backupLog.txt"
GOTO :end

:migration
set /P migSrcLet=What is the drive letter of the drive to migrate from?
IF "%migSrcLet%"=="c" GOTO :cantusecmig
IF "%migSrcLet%"=="C" GOTO :cantusecmig
IF NOT EXIST "%migSrcLet%:\" GOTO :invalidlettermig
IF NOT EXIST "%migSrcLet%:\StaplesBackup" GOTO :nobackupfound

echo Valid selection. Starting Migration from "%migSrcLet%:\StaplesBackup\Backup\Users" to "C:\Users" in 10 seconds.
echo Note: Migration is done to Users folder; if old user folder name is different from new user, unexpected results may occur.
TIMEOUT 10
echo STARTING MIGRATION NOW!

robocopy "%migSrcLet%:\StaplesBackup\Backup\Users" "C:\Users" /v /log:"C:\Users\migrationLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta
echo MIGRATION COMPLETE. Displaying log file.
start "" "C:\Users\migrationLog.txt"
GOTO :end

:migrateoldpc
set /P oldSrcLet=What is the drive letter of the old drive connected as?
IF "%oldSrcLet%"=="c" GOTO :cantusecold
IF "%oldSrcLet%"=="C" GOTO :cantusecold
IF NOT EXIST "%oldSrcLet%:\" GOTO :invalidletterold
IF NOT EXIST "%oldSrcLet%:\Users" GOTO :notoldhdd

echo Valid selection. Starting Migration from old PC "%oldSrcLet%:\Users" to "C:\Users" in 10 seconds.
TIMEOUT 10
echo STARTING MIGRATION FROM OLD PC NOW!

robocopy "%oldSrcLet%:\Users" "C:\Users" /v /log:"C:\Users\migrationOldPCLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "NETUSER.DAT" /xf "NETUSER.DAT*" /xf "netuser.dat.*" /xd "Local Settings" /xd "AppData" /xd "Application Data" /xd "%oldSrcLet%:\Users\All Users" /xd "%oldSrcLet%:\Default User" /xd "%oldSrcLet%:\Users\Default" /xd "%oldSrcLet%:\Users\DefaultAppPool" /xd "%oldSrcLet%:\Users\Default.migrated"
echo MIGRATION FROM OLD PC COMPLETE. Please verify. Displaying log file.
start "" "C:\Users\migrationOldPCLog.txt"
GOTO :end

:clonefolders

:inputCloneSrc
set /P customSrc=What is the source folder? Please include drive letter in path as well as the colon, and use backslashes.
IF NOT EXIST "%cloneSrc%" GOTO :cloneSrcNotExist

:inputCloneDes
set /P cloneDes=What is the destination folder? Please include drive letter in path as well as the colon, and use backslashes.
IF NOT EXIST "%cloneDes%" GOTO :cloneDesNotExist

echo Valid selections. Starting Cloning of "%cloneSrc%" to "%cloneDes%" in 10 seconds.
TIMEOUT 10
echo STARTING CLONING NOW!

robocopy "%cloneSrc%" "%cloneDes%" /v /log:"%cloneDes%\cloneLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj
echo CLONING COMPLETE. Please verify. Displaying log file.
start "" "%cloneDes%\cloneLog.txt"
GOTO :end

:custombackup
echo Custom backups not yet available. Please select something else.
GOTO :mainmenu

:cantusecback
echo C: drive cannot be used as a destination, please select another drive
GOTO :backup

:invalidletterback
echo A drive with that letter is not connected. Please check the letter and try again.
GOTO :backup

:cantusecmig
echo C: drive cannot be used as a source, please select another drive
GOTO :migration

:invalidlettermig
echo A drive with that letter is not connected. Please check the letter and try again.
GOTO :migration

:nobackupfound
echo Staples-made backup not found on the selected drive. Please try again.
GOTO :migration

:cantusecold
echo C: drive cannot be used as a source, please select another drive
GOTO :migrateoldpc

:invalidletterold
echo A drive with that letter is not connected. Please check the letter and try again.
GOTO :migrateoldpc

:notoldpc
echo This drive doesn't look like an old PC's drive. Please try again.
GOTO :migrateoldpc

:cloneSrcNotExist
echo Can't find this source folder. Please double check and try again.
GOTO :inputCloneSrc

:cloneDesNotExist
echo Can't find this destination folder. Please double check and try again.
GOTO :inputCloneDes

:quit
echo "Quitting..."
TIMEOUT 3
GOTO :realend

:end
pause
:realend
