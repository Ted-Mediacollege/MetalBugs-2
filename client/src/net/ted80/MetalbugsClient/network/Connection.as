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
	import net.ted80.MetalbugsClient.world.ChatLog;
	import net.ted80.MetalbugsClient.world.Level;
	import net.ted80.MetalbugsClient.gui.screens.GuiGame;
	import net.ted80.MetalbugsClient.data.Settings;
	import net.ted80.MetalbugsClient.gui.screens.GuiLobby;
	import net.ted80.MetalbugsClient.world.PlayerOther;
	
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
				socketUDP.bind(serverPORT + 2);
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
			var para:Array = e.data.readUTF().split("&");
			
			if (Level.players.playerlist != null)
			{
				var po:PlayerOther = Level.players.playerlist[parseInt(para[0])];
				po.PosX = parseFloat(para[1]);
				po.PosY = parseFloat(para[2]);
				po.VelocityDirection = parseFloat(para[3]);
				po.VelocitySpeed = parseFloat(para[4]);
				po.flashlight = parseInt(para[6]);
				
				if (po.Evolution != parseInt(para[5]))
				{
					po.setEvolution(parseInt(para[5]));
				}
			}
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
			else if (netID == NetworkID.SERVER_JOIN)
			{
				var nameParas:Array = (sa[1] as String).split("&");
				for (var names:int = 0; names < nameParas.length; names++ )
				{
					Level.players.playerlist[names].playerName = (nameParas[names] as String);
				}
			}
			else if (netID == NetworkID.SERVER_LEAVE)
			{
				var leaveID:int = parseInt((sa[1] as String));
				Level.players.removeChild(Level.players.playerlist[leaveID]);
				Level.players.playerlist[leaveID].dis = true;
				ChatLog.addMessage("player" + Level.players.playerlist[leaveID].playerName + " disconnected");
			}
			else if (netID == NetworkID.SERVER_MESSAGE)
			{
				ChatLog.addMessage((sa[1] as String));
			}
			else if (netID == NetworkID.SERVER_SPAWN)
			{
				var para2:Array = (sa[1] as String).split("&");
				Level.players.player.PosX = parseInt((para2[0] as String));
				Level.players.player.PosY = parseInt((para2[1] as String));
			}
			else if (netID == NetworkID.SERVER_END)
			{
				GuiGame.gameEnded = true;
			}
			else if (netID == NetworkID.SERVER_SIZE)
			{
				var size:int = parseInt((sa[1] as String));
				Level.players.player.setEvolution(size);
			}
			else if (netID == NetworkID.SERVER_KILL)
			{
			}
			else if (netID == NetworkID.SERVER_DEATH)
			{
			}
			else if (netID == NetworkID.SERVER_COLSPAWN)
			{
				var para3:Array = (sa[1] as String).split("&");
				var colID:int = parseInt(para3[0]);
				var colX:int = parseInt(para3[1]);
				var colY:int = parseInt(para3[2]);
				Level.collectables.Spawn(colID, colX, colY);
			}
			else if (netID == NetworkID.SERVER_COLDESTROY)
			{
				Level.collectables.Destroy(parseInt((sa[1] as String)));
			}
			else if (netID == NetworkID.SERVER_START)
			{	
				var para1:Array = (sa[1] as String).split("&");
				Settings.MAX_PLAYERS = parseInt((para1[0] as String));
				Settings.GAMELENGTH = parseInt((para1[1] as String));
				Settings.IGNORE = parseInt((para1[2] as String));
				GuiLobby.started = true;
				GuiLobby.spawnX = parseInt((para1[3] as String));
				GuiLobby.spawnY = parseInt((para1[4] as String));
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