<#
    .Description
    Läd das aktuelle Hintergrundbild von Bing.com und ersetzt das aktuelle Wallpaper
#>
function Set-BingWallpaper {
    param (
        [Switch] $Force = $True,
		[int] $Offset = 0
    )
    
    [String] $url = $("https://www.bing.com/HPImageArchive.aspx?format=xml&idx=" + $Offset +"&n=1&mkt=de-DE")
    [String] $imgurl = "https://www.bing.com"

    # Bildurl parsen
    $wc = New-Object net.webclient
    $xml = [xml] $wc.DownloadString($url)
    $imgurl += $xml.images.image.url.Trim()
	[String] $FileName = $imgurl -replace '^.+rf=([^&]+).+$','$1'
	[String] $FilePath = $(${env:temp} + '\' + $FileName)

    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value ""
    rundll32.exe user32.dll, UpdatePerUserSystemParameters

	if(Test-Path $FilePath) {
		Remove-Item $FilePath
	}
	
    # Bild herunterladen
    $wc.DownloadFile($imgurl, $FilePath);
    
    # Bild aktualisieren
    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $FilePath
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
	
}
Set-Alias w-wallpaper Set-BingWallpaper
