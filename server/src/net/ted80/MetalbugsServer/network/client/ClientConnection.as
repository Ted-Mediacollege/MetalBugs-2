package net.ted80.MetalbugsServer.network.client 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import net.ted80.MetalbugsServer.data.ServerLog;
	import net.ted80.MetalbugsServer.network.NetworkID;
	
	public class ClientConnection 
	{
		public var socket:Socket;
		public var remoteAdress:String;
		public var disconnected:Boolean;
		
		public var networkID:int;
		public var playerName:String = "Player";
		public var playerID:int;
		public var ready:Boolean;
		
		public var posX:Number = 0;
		public var posY:Number = 0;
		public var velD:Number = 0;
		public var velS:Number = 0;
		public var size:int = 0;
		public var flashLight:int = 0;
		
		public function ClientConnection(s:Socket, nid:int, pid:int) 
		{
			networkID = nid;
			playerID = pid;
			ready = false;
			
			socket = s;
			socket.addEventListener(Event.CLOSE, onClientLost);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onNetworkError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onRecieveData);
			
			remoteAdress = socket.remoteAddress;
			disconnected = false;
		}
		
		public function forceClose():void
		{
			socket.removeEventListener(Event.CLOSE, onClientLost);
			socket.removeEventListener(IOErrorEvent.IO_ERROR, onNetworkError);
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, onRecieveData);
			socket.close();
			disconnected = true;
		}
		
		public function onClientLost(e:Event):void
		{
			ServerLog.addMessage("NETWORK", "Connection closed! " + remoteAdress);
			disconnected = true;
		}
		
		public function onNetworkError(e:IOErrorEvent):void
		{
			ServerLog.addMessage("NETWORK", "Lost client due to network error! " + remoteAdress);
			socket.close();
			disconnected = true;
		}
		
		public function onUDPupdate(s:String):void
		{
			var sa:Array = s.split("#");
			var para:Array = sa[1].split("&");
			
			posX = parseFloat(para[0]);
			posY = parseFloat(para[1]);
			velD = parseFloat(para[2]);
			velS = parseFloat(para[3]);
			size = parseInt(para[4]);
			flashLight = parseInt(para[5]);
		}
		
		public function onRecieveData(e:ProgressEvent):void
		{
			var s:String = socket.readUTF();
			var sa:Array = s.split("#");
			
			var netID:int = parseInt(sa[0]);
			if (netID == NetworkID.CLIENT_WELCOME)
			{
				playerName = sa[1];
				ServerLog.addMessage("LOBBY", playerName + " joined the game!");
				ready = true;
			}
		}
		
		public function send(s:String):void
		{
			socket.writeUTF(s);
			socket.flush();
		}
	}
}