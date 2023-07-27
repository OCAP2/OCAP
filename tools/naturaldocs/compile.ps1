exit

# Download NaturalDocs 1.5.2 from here https://sourceforge.net/projects/naturaldocs/files/Stable%20Releases/1.52/NaturalDocs-1.52.zip/download
# Set path to the extracted folder
$NaturalDocsPath = "C:\Users\indif\Downloads\NaturalDocs"
$PathToOcapRoot = "C:\Users\indif\Git\OCAP"


# For the addon
$PathToOcapAddons = $PathToOcapRoot + "\addon\x\ocap\addons"
$PathToProjectFolder = $PathToOcapRoot + "\tools\naturaldocs"
$PathToOcapDocs = $PathToOcapRoot + "\addon\docs"

$Modules = @("main", "extension", "recorder")
$OutText = ""
ForEach ($Module in $Modules) {
  $GroupText = "Group: $Module {`n"
  $Files = Get-ChildItem -LiteralPath ("{0}\{1}" -f $PathToOcapAddons, $Module)
  ForEach ($File in $Files) {
    $GroupText += ("  File: OCAP_{0}_{1} ({2}\{3})`n" -f @($module, $File.Name.Replace('.sqf',''), $File.Directory.Name, $File.Name))
  }
  $GroupText += "} # Group: $Module`n"
  $OutText += $GroupText
}

$OutText | clip

Set-Location $NaturalDocsPath
. .\NaturalDocs.bat -p $PathToProjectFolder -i $PathToOcapAddons -o "HTML" $PathToOcapDocs -ro -hl All