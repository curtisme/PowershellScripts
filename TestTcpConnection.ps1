function TestTcpConnection
{
    param([string]$hostName, [int]$port)
    $streamType = [system.net.sockets.sockettype]::stream
    $tcpType = [system.net.sockets.protocoltype]::tcp
    $addressFamily = [system.net.sockets.addressfamily]::internetwork
    $socket = new-object -typename system.net.sockets.socket -argumentlist $addressFamily, $streamType, $tcpType
    try
    {
        $socket.connect($hostname, $port)
        $socket.close()
        write-host "TCP connection succesfully established"
    }
    catch
    {
        write-host $_
    }
}
