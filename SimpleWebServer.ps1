function RunWebServer
{
    param([string]$prefix)
    $listener = new-object -typename system.net.httplistener
    try
    {
        $listener.prefixes.add($prefix)
        $listener.start()
        try
        {
            while($true)
            {
                $context = $listener.getcontext()
                $req = $context.request
                $res = $context.response
                if ($req.url.localpath -eq "/") {$path = "./index.html"}
                else {$path = "." + $req.url.localpath}
                if (test-path $path)
                {
                    $content = get-content -encoding byte -path $path
                }
                else
                {
                    $res.statuscode = 404
                    $content = [text.encoding]::utf8.getbytes("not found")
                }
                $res.outputstream.write($content, 0, $content.length)
                $res.close()
            }
        }
        catch
        {
            $listener.stop()
            throw
        }
    }
    catch
    {
        write-host $_
    }
}
