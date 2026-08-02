Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Konstantin\Documents\new-detective\Asserts\19598325.jpg")
Write-Host "Size: $($bmp.Width) x $($bmp.Height)"
for ($x = 0; $x -lt 60; $x++) {
    $c = $bmp.GetPixel($x, 0)
    Write-Host "$x : $($c.R),$($c.G),$($c.B)"
}
$bmp.Dispose()
