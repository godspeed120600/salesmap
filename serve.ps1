$port = 3000
$dir = $PSScriptRoot

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Prefixes.Add("http://+:$port/")
$listener.Start()
Write-Host "Serving at http://localhost:$port (and on the LAN IP for mobile access)"

while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response

    try {
        $path = $req.Url.LocalPath.TrimStart('/')
        if ($path -eq '' -or $path -eq '/') { $path = 'index.html' }
        $fullPath = Join-Path $dir $path

        if (Test-Path $fullPath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($fullPath)
            $mime = switch ($ext) {
                '.html' { 'text/html; charset=utf-8' }
                '.css'  { 'text/css' }
                '.js'   { 'application/javascript' }
                default { 'application/octet-stream' }
            }
            $bytes = [System.IO.File]::ReadAllBytes($fullPath)
            $res.StatusCode = 200
            $res.ContentType = $mime
            $res.SendChunked = $false
            $res.ContentLength64 = [long]$bytes.Length
            $stream = $res.OutputStream
            $stream.Write($bytes, 0, $bytes.Length)
            $stream.Flush()
        } else {
            $body = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found')
            $res.StatusCode = 404
            $res.SendChunked = $false
            $res.ContentLength64 = [long]$body.Length
            $res.OutputStream.Write($body, 0, $body.Length)
        }
    } catch {
        Write-Host "Request error: $_"
    } finally {
        try { $res.OutputStream.Close() } catch {}
    }
}
