@echo off
:: 백업 스케줄 bat 파일
title PC 데이터 자동백업

echo.
echo =============================================================
echo                 PC 데이터 자동백업  					
echo =============================================================
echo.   															
echo  □ 사용자 PC 데이터 자동백업   								
echo  □ 백업시간: 매일 2회 백업 (1차: 12:10, 2차: 17:10)  		
echo  □ 백업대상: (C:\), (D:\), (E:\)   							
echo  □ 소요시간: 약 30초   										
echo.   															
echo  ▷ 본 자동백업은 랜섬웨어/바이러스 감염으로 인한 내부 데이터  
echo     손상방지 목적이므로 창을 종료하지 마시고 자동백업이 완료  
echo     될때 까지 기다려 주시기 바랍니다.  						
echo.
echo.           												
echo  [문의처] 
echo.
	
echo.

wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "RestorePointName", 100, 7 2>&1>nul
