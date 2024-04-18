@echo off

title Windows VSS backup 활성화

:: cmd 파일을 실행하면 스케줄러 cmd를 경로에 복사하고 실행
:: 12:10 17:10 에 복사된 cmd를 실행하는 스케줄러로 백업 실행

:: 기존 cmd 파일 삭제
del /q C:\Domain\vss_backup_schedule.cmd
del /q C:\Domain\vss_backup_start.cmd

:: Windows VSS backup 보호 활성화
powershell -command Enable-ComputerRestore "c:", "d:", "e:"

:: VSS backup 횟수제한 해제 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v SystemRestorePointCreationFrequency /t REG_DWORD /d 0 /f

:: 드라이브 백업 용량 설정 (각각 10%)
vssadmin resize shadowstorage /on=c: /for=c: /maxsize=10%%
vssadmin resize shadowstorage /on=d: /for=d: /maxsize=10%%
vssadmin resize shadowstorage /on=e: /for=e: /maxsize=10%%

:: 백업 스케줄 삭제 (이전버전)
schtasks /delete /tn "OS복원지점 백업-1차" /f
schtasks /delete /tn "OS복원지점 백업-2차" /f

:: 백업 스케줄 생성
:: /sc daily인 경우 /mo가 생략되면 기본값은 1이다. /sc daily에서 /mo의 유효값은 1-365일이다.+
schtasks /create /tn "VSS_BACKUP_1차" /tr C:\Domain\vss_backup_schedule.cmd /sc daily /st 12:10 /f
schtasks /create /tn "VSS_BACKUP-2차" /tr C:\Domain\vss_backup_schedule.cmd /sc daily /st 17:10 /f

:: vss_backup_schedule.cmd 파일 복사
set "ScriptPath=%~dp0vss_backup_schedule.cmd"
set "DestinationPath=C:\Domain\vss_backup_schedule.cmd"
copy /Y "%ScriptPath%*" "%DestinationPath%"
:: vss_backup_schedule.cmd 실행 후 첫 백업 실행
start "" "%DestinationPath%"

