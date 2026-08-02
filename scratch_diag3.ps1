Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Konstantin\Documents\new-detective\Asserts\19598325.jpg")
$x = 100
$prev = $null
for ($y = 0; $y -lt 900; $y++) {
    $c = $bmp.GetPixel($x, $y)
    $key = "$($c.R),$($c.G),$($c.B)"
    if ($key -ne $prev) {
        Write-Host "y=$y -> $key"
        $prev = $key
    }
}
$bmp.Dispose()
