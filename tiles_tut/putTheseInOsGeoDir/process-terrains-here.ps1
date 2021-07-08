Write-Host "This script should be placed in your OSGeo4W64 directory along with the trimmed PNGs at 16834 by 16384 resolution you've prepared."
Pause

Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'Microsoft.VisualBasic'

Remove-Item ".\temp.vrt" -Force -EA SilentlyContinue

$TerrainPNGs = Get-ChildItem -File -Filter '*.png' | ForEach-Object Name
ForEach ($Terrain in $TerrainPNGs) {
	$TerrainName = $Terrain.Substring(0, $Terrain.Length - 4)

	try {
		$ID = (Start-Process 'cmd.exe' -ArgumentList @("/c OSGeo4W.bat") -PassThru).id 
		Start-Sleep 1
		[Microsoft.VisualBasic.Interaction]::AppActivate([Int32]$ID)
		[System.Windows.Forms.SendKeys]::SendWait("py3_env~")
		[System.Windows.Forms.SendKeys]::SendWait("gdal_translate -of vrt -expand rgba $Terrain temp.vrt~")
		[System.Windows.Forms.SendKeys]::SendWait("gdal2tiles_legacy_no-tms -p raster -z 0-6 temp.vrt~")
	
	} catch {
		Write-Error $PSItem
	}

	Start-Sleep 2

	if (!(Test-Path ".\temp.vrt")) {
		try {
			[System.Windows.Forms.SendKeys]::SendWait("py3_env~")
			[System.Windows.Forms.SendKeys]::SendWait("gdal2tiles_legacy_no-tms -p raster -z 0-6 $Terrain~")
			[System.Windows.Forms.SendKeys]::SendWait("exit~")
		} catch {
			Write-Error $PSItem
			continue
		}
	} else {

		[System.Windows.Forms.SendKeys]::SendWait("exit~")
		Write-Host "$Terrain processed. Please rename the folder and prepare for the next one to run."
		Pause

		Remove-Item ".\temp.vrt" -Force -EA SilentlyContinue
	}
}