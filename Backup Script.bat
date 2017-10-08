@echo off
echo Welcome to Staples Store #17 Tech Backup & Migrate script!

:mainmenu
echo 
echo MAIN MENU
echo 1. Backup Data
echo 2. Migrate Data [COMING SOON]
SET /P backMigSel=What would you like to do? 

IF "%backMigSel%"=="1" GOTO :backup
echo Not a valid selection, please try again.
GO TO :mainmenu

:backup
SET /P backDestLet=What is the drive letter of the drive to put the backup unto? 
IF /I "%backDestLet%"=="c" GOTO :invalidletter
IF NOT EXIST "backDestLet%:\" GOTO :invalid letter

mkdir "%backDestLet%:\StaplesBackup"
mkdir "%backDestLet%:\StaplesBackup\Users"
robocopy "C:\Users" "%backDestLet%:\StaplesBackup\Users" /v /log:"%backDestLet%:\backupLog.txt" /e /zb /mt:4 /r:3 /w:3 /copy:dt /tee /eta /xj /xf "NETUSER.DAT" /xd "Local Settings" /xd "AppData" /xd "Application Data" /xd "C:\Users\All Users" /xd "C:\Default User" /xd "C:\Users\Default" /xd "C:\Users\DefaultAppPool" /xd "C:\Users\Default.migrated"
echo "BACKUP COMPLETE. Displaying log file.
start "" "E:\backupLog.txt"
GOTO :end

:backupextrafolders
SET extracount=0
:backupextrainput
SET /P backupExtraInput=Would you like to backup folders not present under Users[y/n]? 
IF "%backupExtraInput%"=="y" GOTO :extrabackuploop
IF "%backupExtraInput%"=="n" GOTO :end
echo Invalid selection, please type y or n.
GOTO :backupextrainput

:extrabackuploop
SET /A extracount=extracount+1
mkdir "%backDestLet%:\StaplesBackup\Extra%extracount%"
SET /P backupExtraPath=What is the full path of the extra folder number %extracount%? 

:invalidletter
echo This is an invalid selection, try again.
GOTO :mainmenu

:end
echo TASKS COMPLETE. YOU HAVE REACHED THE END OF THE SCRIPT.
pause
