set _in=H:\
set _out=H:\
set _arcpath=F:\Program Files\7-Zip
for /F "delims=" %%A in ('dir "%_in%" /AD /B') do "%_arcpath%\7z" a "%_out%\%%~nA.zip" "%_in%\%%A"