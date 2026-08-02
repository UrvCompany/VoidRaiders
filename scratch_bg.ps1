Add-Type -AssemblyName System.Drawing

$src = "C:\Users\Konstantin\Documents\new-detective\Asserts\19598325.jpg"
$dst = "C:\Users\Konstantin\Documents\new-detective\Asserts\19598325_transparent.png"

$csharp = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Collections.Generic;

public static class BgRemover
{
    public static void Process(string inPath, string outPath, double cellSize)
    {
        using (Bitmap src = new Bitmap(inPath))
        {
            int w = src.Width, h = src.Height;
            using (Bitmap bmp = new Bitmap(w, h, PixelFormat.Format32bppArgb))
            {
                using (Graphics g = Graphics.FromImage(bmp))
                {
                    g.DrawImage(src, 0, 0, w, h);
                }
                BitmapData bd = bmp.LockBits(new Rectangle(0,0,w,h), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
                int stride = bd.Stride;
                int total = stride * h;
                byte[] buf = new byte[total];
                Marshal.Copy(bd.Scan0, buf, 0, total);

                bool[] strict = new bool[w*h];
                for (int y=0;y<h;y++)
                {
                    int rowOff = y*stride;
                    int cj = (int)Math.Floor(y / cellSize);
                    for (int x=0;x<w;x++)
                    {
                        int off = rowOff + x*4;
                        int b = buf[off];
                        int gC = buf[off+1];
                        int r = buf[off+2];
                        int maxc = Math.Max(r, Math.Max(gC,b));
                        int minc = Math.Min(r, Math.Min(gC,b));
                        bool isGray = (maxc - minc) <= 14;
                        if (!isGray) { continue; }
                        int avg = (r+gC+b)/3;
                        int ci = (int)Math.Floor(x / cellSize);
                        bool expectGray = ((ci+cj) % 2 != 0);
                        int expected = expectGray ? 193 : 255;
                        strict[y*w+x] = Math.Abs(avg-expected) <= 14;
                    }
                }

                // morphological dilation (radius 2) to bridge 1-2px jpeg seam lines
                int R = 2;
                bool[] dilated = new bool[w*h];
                for (int y=0;y<h;y++)
                {
                    for (int x=0;x<w;x++)
                    {
                        if (strict[y*w+x]) { dilated[y*w+x] = true; continue; }
                        bool found = false;
                        for (int dy=-R; dy<=R && !found; dy++)
                        {
                            int ny = y+dy;
                            if (ny<0||ny>=h) continue;
                            for (int dx=-R; dx<=R; dx++)
                            {
                                int nx = x+dx;
                                if (nx<0||nx>=w) continue;
                                if (strict[ny*w+nx]) { found = true; break; }
                            }
                        }
                        dilated[y*w+x] = found;
                    }
                }

                bool[] bg = new bool[w*h];
                Queue<int> q = new Queue<int>();

                Action<int,int> seed = (x,y) => {
                    int idx = y*w+x;
                    if (dilated[idx] && !bg[idx]) { bg[idx]=true; q.Enqueue(idx); }
                };

                for (int x=0;x<w;x++) { seed(x,0); seed(x,h-1); }
                for (int y=0;y<h;y++) { seed(0,y); seed(w-1,y); }

                while (q.Count>0)
                {
                    int idx = q.Dequeue();
                    int x = idx % w;
                    int y = idx / w;
                    if (x>0) seed(x-1,y);
                    if (x<w-1) seed(x+1,y);
                    if (y>0) seed(x,y-1);
                    if (y<h-1) seed(x,y+1);
                }

                int removedCount = 0;
                for (int y=0;y<h;y++)
                {
                    int rowOff = y*stride;
                    for (int x=0;x<w;x++)
                    {
                        if (bg[y*w+x])
                        {
                            int off = rowOff + x*4;
                            buf[off+3] = 0;
                            removedCount++;
                        }
                    }
                }

                Marshal.Copy(buf, 0, bd.Scan0, total);
                bmp.UnlockBits(bd);
                bmp.Save(outPath, ImageFormat.Png);
                Console.WriteLine("removed=" + removedCount + " total=" + (w*h));
            }
        }
    }
}
"@

Add-Type -TypeDefinition $csharp -ReferencedAssemblies System.Drawing.dll -ErrorAction Stop
[BgRemover]::Process($src, $dst, 74.573)
Write-Host "Done -> $dst"
