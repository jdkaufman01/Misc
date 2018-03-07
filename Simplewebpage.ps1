
$SimpleServer = New-Object Net.HttpListener
$SimpleServer.Prefixes.add("http://localhost:8000/")
$SimpleServer.Start()
Start-Process "http://localhost:8000/" 
$Context = $SimpleServer.GetContext()

$result = " Hello World! "
$buffer = [System.Text.Encoding]::ASCII.GetBytes($result)
$context.Response.ContentLength64 = $buffer.Length
$context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
$Context.Response.Close()
$SimpleServer.Stop()
