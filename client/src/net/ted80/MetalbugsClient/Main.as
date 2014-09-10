package net.ted80.MetalbugsClient 
{
	import flash.display.Sprite;
	import net.ted80.MetalbugsClient.network.Connection;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class Main extends Sprite
	{		
		public static var connection:Connection;
		
		public function Main() 
		{
			connection = new Connection("ClientName");
			connection.serverIP = "192.168.178.12";
			connection.serverPORT = 2022;
			connection.connect();
			
			addEventListener(Event.ENTER_FRAME, tick);
		}
		
		public function tick(e:Event):void
		{
			//var ba:ByteArray = new ByteArray();
			//ba.writeUTF("test");
			//connection.socketUDP.send(ba, 0, 0, connection.serverIP, connection.serverPORT + 1);
			//trace("sending...");
		}
	}
}