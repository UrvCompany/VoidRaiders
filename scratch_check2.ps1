Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\Konstantin\Documents\new-detective\Asserts\19598325.jpg")
$pts = @(@(10,10),@(3700,10),@(10,5900),@(1860,50),@(1860,3000),@(600,1500),@(3200,1500),@(0,0),@(50,50),@(100,100))
foreach ($p in $pts) {
    $c = $bmp.GetPixel($p[0],$p[1])
    Write-Host "($($p[0]),$($p[1])) R=$($c.R) G=$($c.G) B=$($c.B)"
}
$bmp.Dispose()
