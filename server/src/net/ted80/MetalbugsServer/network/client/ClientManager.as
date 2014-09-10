package net.ted80.MetalbugsServer.network.client 
{
	import flash.events.DatagramSocketDataEvent;
	import flash.net.DatagramSocket;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import flash.utils.ByteArray;
	import net.ted80.MetalbugsServer.data.ServerLog;
	import net.ted80.MetalbugsServer.network.NetworkID;
	import net.ted80.MetalbugsServer.data.GameState;
	
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
			udpSocket.bind(2022 + 1);
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
			if(!GameState.LOBBY) //REJECT IF NOT IN LOBBY
			{
				ServerLog.addMessage("NETWORK", "Rejected connection " + e.socket.remoteAddress + ", Reason: Game is already playing");
				e.socket.writeUTF(NetworkID.SERVER_REJECT + "#" + NetworkID.REJECT_PLAYING);
				e.socket.flush();
			}
			else
			{
				var nextPlayerID:int = getNextAvailibleID();
				ServerLog.addMessage("NETWORK", "Incomming connection! " + e.socket.remoteAddress + " PlayerID: " + nextPlayerID);
				e.socket.writeUTF(NetworkID.SERVER_WELCOME + "#" + nextNetworkID + "&" + nextPlayerID);
				e.socket.flush();
				clients.push(new ClientConnection(e.socket, nextNetworkID, nextPlayerID));
				nextNetworkID++;
			}
		}
		
		public function onUDPdata(e:DatagramSocketDataEvent):void
		{
			var str:String = e.data.readUTF();
			var id:int = parseInt((str.split("#"))[0]);
			for (var i:int = clients.length - 1; i > -1; i-- )
			{
				if (clients[i].networkID == id)
				{
					clients[i].onUDPupdate(str);
				}
			}
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
		
		public function sendAllPostitions():void
		{
			for (var i:int = 0; i < clients.length; i++) 
			{
				sendUDPToAllExcept(
					clients[i].playerID + "&" + 
					clients[i].posX + "&" + 
					clients[i].posY + "&" + 
					clients[i].velD + "&" + 
					clients[i].velS + "&" + 
					clients[i].size + "&" + 
					clients[i].flashLight,
					clients[i].playerID);
			}
		}
		
		public function sendMessageToAll(id:int, message:String):void
		{
			sendMessageToAllExcept(id, message, -1);
		}
			
		public function sendUDPToAll(message:String):void
		{
			sendUDPToAllExcept(message, -1);
		}
		
		public function sendUDPToAllExcept(message:String, playerID:int):void
		{
			for (var i:int = 0; i < clients.length; i++ )
			{
				if (clients[i].playerID != playerID)
				{
					var ba:ByteArray = new ByteArray();
					ba.writeUTF(message);
					udpSocket.send(ba, 0, 0, clients[i].socket.remoteAddress, clients[i].socket.remotePort);
				}
			}
		}
		
		public function sendMessageToAllExcept(id:int, message:String, playerID:int):void
		{
			for (var i:int = 0; i < clients.length; i++ )
			{
				if (clients[i].playerID != playerID)
				{
					clients[i].send(id + "#" + message);
				}
			}
		}
		
		public function sendMessageToClient(id:int, message:String, c:int):void
		{
			if (c < clients.length)
			{
				clients[c].send(id + "#" + message);
			}
		}
		
		public function getNextAvailibleID():int
		{
			if (clients.length == 0)
			{
				return 0;
			}
			
			for (var id:int = 0; id < 100; id++ )
			{
				var l:int = clients.length;
				for (var p:int = 0; p < l; p++ )
				{
					if (id == clients[p].playerID)
					{
						break;
					}
					if (p == l - 1)
					{
						return id;
					}
				}
			}
			return -1;
		}
	}
}