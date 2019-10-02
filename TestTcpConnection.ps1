function TestTcpConnection {
    param([string]$ipaddressString, [int]$port)
    $streamType = [system.net.sockets.sockettype]::stream
    $tcpType = [system.net.sockets.protocoltype]::tcp
    $octets = $ipaddressString.split('.')
    $ipAddressInt64 = [int]$octets[0] * [math]::pow(256,0) +
                      [int]$octets[1] * [math]::pow(256,1) +
                      [int]$octets[2] * [math]::pow(256,2) +
                      [int]$octets[3] * [math]::pow(256,3)
    $ipaddress = new-object -typename system.net.ipaddress -argumentlist $ipaddressInt64
    $endpoint = new-object -typename system.net.ipendpoint -argumentlist $ipaddress, $port
    $socket = new-object -typename system.net.sockets.socket -argumentlist $ipaddress.addressfamily, $streamType, $tcpType
    try {
        $socket.connect($endpoint)
        $socket.close()
        write-host "TCP connection succesfully established"
    }
    catch {
        write-host $_
    }
}


TestTcpConnection $args[0] $args[1]
