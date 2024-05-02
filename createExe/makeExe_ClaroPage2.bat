set sourFold=c:\MyDocuments\ate\AutoTesters\Tools\AT-ClaroPage2\software\
REM set copyToFold=c:\SolderingMachinesStats\ShowStats\ 
REM set copyToFold=c:\MyDocuments\ate\AutoTesters\Tools\AT-SerNumClei2Page0\software\exe\

del Page2.exe
del %copyToFold%\Page2.exe
del rls.txt
del pack.txt
del sw.txt

dir /s /b .\rls > rls.txt  

dir /s /b .\snack2.2 > packs.txt
dir /s /b .\BWidget1.9.8 >> packs.txt  
REM dir /s /b .\tablelist >> packs.txt 
dir /s /b .\img_base1.4.3 >> packs.txt 
dir /s /b .\img_gif1.4.3 >> packs.txt 
dir /s /b .\img_ico1.4.3 >> packs.txt 
dir /s /b .\img_jpeg1.4.3 >> packs.txt 
dir /s /b .\img_png1.4.3 >> packs.txt 
dir /s /b .\jpegtcl8.4 >> packs.txt 
dir /s /b .\pngtcl1.4.12 >> packs.txt 
REM dir /s /b .\zlibtcl1.2.8 >> packs.txt 
REM dir /s /b .\ezsmtp1.0.0 >> packs.txt 

echo %sourFold%\Page2.tcl > sw.txt
echo %sourFold%\Gen_ClaroPage2.tcl >> sw.txt
echo %sourFold%\Ds280e01_ClaroPage2.tcl >> sw.txt
echo %sourFold%\Gui_ClaroPage2.tcl >> sw.txt
echo %sourFold%\Main_ClaroPage2.tcl >> sw.txt
echo %sourFold%\Lib_Put_Etx2i10G.tcl >> sw.txt
echo %sourFold%\Lib_DialogBox.tcl>> sw.txt
echo %sourFold%\init.tcl>> sw.txt
echo %sourFold%\question.gif>> sw.txt
echo %sourFold%\error.gif>> sw.txt
echo %sourFold%\info.gif>> sw.txt
REM dir /b /s %sourFold%\images >> sw.txt


start /wait freewrap.exe -debug %sourFold%\Page2.tcl -f sw.txt -f packs.txt -f rls.txt

REM copy ShowStatistics.exe %copyToFold% 
set sourFold=
REM set copyToFold=
  