package net.ted80.MetalbugsServer.network.client 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import net.ted80.MetalbugsServer.data.ServerLog;
	
	public class ClientConnection 
	{
		public var networkID:int;
		public var socket:Socket;
		public var remoteAdress:String;
		public var disconnected:Boolean;
		
		public function ClientConnection(s:Socket, id:int) 
		{
			networkID = id;
			
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
			ServerLog.addMessage("NETWORK", "Connection timed-out " + remoteAdress);
			disconnected = true;
		}
		
		public function onNetworkError(e:IOErrorEvent):void
		{
			ServerLog.addMessage("NETWORK", "Lost client due to network error! " + remoteAdress);
			socket.close();
			disconnected = true;
		}
		
		public function onRecieveData(e:ProgressEvent):void
		{
		}
	}
}