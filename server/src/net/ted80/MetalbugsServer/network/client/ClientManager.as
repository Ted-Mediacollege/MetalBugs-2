package net.ted80.MetalbugsServer.network.client 
{
	import flash.events.DatagramSocketDataEvent;
	import flash.net.DatagramSocket;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import net.ted80.MetalbugsServer.data.ServerLog;
	
	public class ClientManager 
	{
		public var tcpSocket:ServerSocket;
		public var udpSocket:DatagramSocket;
		
		public var clients:Vector.<ClientConnection>;
		public var nextNetworkID:int;
		
		public function ClientManager() 
		{
			tcpSocket = new ServerSocket();
			tcpSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onIncommingConnection);
			tcpSocket.bind(2022);
			tcpSocket.listen();
			ServerLog.addMessage("NETWORK", "TCP connection is ready!");
			
			udpSocket = new DatagramSocket();
			udpSocket.addEventListener(DatagramSocketDataEvent.DATA, onUDPdata);
			udpSocket.bind(2023);
			udpSocket.receive();
			ServerLog.addMessage("NETWORK", "UDP connection is ready!");
			
			clients = new Vector.<ClientConnection>();
			nextNetworkID = 0;
		}
		
		public function destroy():void
		{
			tcpSocket.close();
			tcpSocket.removeEventListener(ServerSocketConnectEvent.CONNECT, onIncommingConnection);
			
			udpSocket.close();
			udpSocket.removeEventListener(DatagramSocketDataEvent.DATA, onUDPdata);
			
			for (var i:int = clients.length - 1; i > -1; i-- )
			{
				clients[i].forceClose();
			}
		}

		public function onIncommingConnection(e:ServerSocketConnectEvent):void
		{
			ServerLog.addMessage("NETWORK", "Incomming connection! " + e.socket.remoteAddress);
			clients.push(new ClientConnection(e.socket, nextNetworkID));
			nextNetworkID++;
		}
		
		public function onUDPdata(e:DatagramSocketDataEvent):void
		{
			//use network id to find client
			trace("UDP data!");
		}
		
		public function tick():void
		{
			for (var i:int = clients.length - 1; i > -1; i-- )
			{
				if (clients[i] != null)
				{
					if (clients[i].disconnected)
					{
						clients[i] = null;
						clients.splice(i, 1);
					}
				}
				else
				{
					clients.splice(i, 1);
				}
			}
		}
	}
}