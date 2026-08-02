Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Konstantin\Documents\new-detective\Asserts\19598325.jpg")
$y = 100
$prev = $null
for ($x = 0; $x -lt 1200; $x++) {
    $c = $bmp.GetPixel($x, $y)
    $key = "$($c.R),$($c.G),$($c.B)"
    if ($key -ne $prev) {
        Write-Host "x=$x -> $key"
        $prev = $key
    }
}
$bmp.Dispose()
