package net.ted80.MetalbugsClient.network 
{
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.DatagramSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class Connection 
	{		
		public var socketTCP:Socket;
		public var socketUDP:DatagramSocket;
		
		public var serverIP:String;
		public var serverPORT:int;
		
		public var connected:Boolean;
		public var failed:Boolean;
		
		public var networkID:int;
		public var playerID:int;
		public var playerName:String;
		
		public function Connection() 
		{
			serverIP = "127.0.0.1";
			serverPORT = 2022;
			playerName = "RandomGuy";
			
			socketTCP = new Socket();
			socketTCP.addEventListener(Event.CONNECT, onConnect);
			socketTCP.addEventListener(Event.CLOSE, onDisconnect);
			socketTCP.addEventListener(ProgressEvent.SOCKET_DATA, onRecieveData);
			socketTCP.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socketTCP.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			socketUDP = new DatagramSocket();
			socketUDP.addEventListener(DatagramSocketDataEvent.DATA, onUDPdata);
		}	
		
		public function connect():void
		{
			try
			{
				connected = false;
				failed = false;
				
				socketTCP.connect(serverIP, serverPORT);
				socketUDP.bind(serverPORT + 1);
				socketUDP.receive();
			}
			catch (e:Error)
			{
				trace("Cannot connect!");
			}
		}
		
		public function onConnect(e:Event):void
		{
			connected = true;
		}
		
		public function onDisconnect(e:Event):void
		{
			connected = false;
		}
		
		public function onIOError(e:IOErrorEvent):void
		{
			trace("NETWORK IO ERROR");
			failed = true;
			connected = false;
		}
		
		public function onSecurityError():void
		{
			trace("SECURITY ERROR");
			failed = true;
			connected = false;
		}
		
		public function onUDPdata(e:DatagramSocketDataEvent):void
		{
			trace("incomming udp data");
		}
		
		public function onRecieveData(e:ProgressEvent):void
		{
			var s:String = socketTCP.readUTF();
			var sa:Array = s.split("#");
			var netID:int = parseInt(sa[0]);
			var para:Array;
			
			if (netID == NetworkID.SERVER_WELCOME)
			{
				para = sa[1].split("&");
				networkID = parseInt(para[0]);
				playerID = parseInt(para[1]);
				
				sendTCP(NetworkID.CLIENT_WELCOME + "#" + playerName);
			}
		}
		
		public function tick():void
		{
			
		}
		
		public function sendTCP(s:String):void
		{
			socketTCP.writeUTF(s);
			socketTCP.flush();
		}
	}
}