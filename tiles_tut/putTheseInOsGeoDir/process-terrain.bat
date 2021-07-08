@echo off
rem Root OSGEO4W home dir to the same directory this script exists in
call "%~dp0\bin\o4w_env.bat"

rem List available o4w programs
rem but only if osgeo4w called without parameters
@echo on

"Starting python env"
@py3_env
"Starting gdal_translate"
@gdal_translate -of vrt -expand rgba "%1" temp.vrt
"Starting gdal2tiles_legacy_no-tms"
@gdal2tiles_legacy_no-tms -p raster -z 0-6 temp.vrt