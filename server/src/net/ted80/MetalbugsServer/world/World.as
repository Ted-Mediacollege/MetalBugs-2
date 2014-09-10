package net.ted80.MetalbugsServer.world 
{
	import flash.events.Event;
	import net.ted80.MetalbugsServer.Main;
	import net.ted80.MetalbugsServer.data.ServerLog;
	import net.ted80.MetalbugsServer.network.client.ClientConnection;
	import net.ted80.MetalbugsServer.network.NetworkID;
	import net.ted80.MetalbugsServer.data.GameState;
	import net.ted80.MetalbugsServer.util.MathHelper;
	
	public class World
	{	
		public static var levelSize:int = 4000;
		
		public var frameLeft:int;
		public var timeLeft:int;
		
		public var timer_ready:int;
		public var timer_pos:int;
		public var timer_col:int;
		public var timer_yolomode:int;
		public var timer_wait:int;
		
		public var nextcolID:int;
		
		public var collectableList:Vector.<Collectable>;
		
		public function World() 
		{
			GameState.LOBBY = true;
			GameState.PLAYING = false;
		}
		
		public function tick():void
		{
			if (GameState.PLAYING)
			{
				frameLeft--;
				if (frameLeft < 0)
				{
					timeLeft--;
					if (timeLeft < 0)
					{
						end();
						return;
					}
					frameLeft += 30;
				}
				
				timer_pos--;
				if (timer_pos < 0)
				{
					timer_pos = 8;
					Main.clientManager.sendAllPostitions();
				}
								
				timer_col--;
				if (timer_col < 0)
				{
					timer_col = 300;
					if (collectableList.length < 10)
					{
						var c:Collectable = new Collectable(nextcolID, 50 + MathHelper.nextInt(1500), 50 + MathHelper.nextInt(1500));
						collectableList.push(c);
						nextcolID++;
						Main.clientManager.sendMessageToAll(NetworkID.SERVER_COLSPAWN, c.id + "&" + c.posX + "&" + c.posY);
					}
				}
				
				for (var p7:int = Main.clientManager.clients.length - 1; p7 > -1; p7-- )
				{
					if (Main.clientManager.clients[p7].size > 8)
					{
						end();
						return;
					}
				}
				
				for (var p:int = Main.clientManager.clients.length - 1; p > -1; p-- )
				{
					var px:Number = Main.clientManager.clients[p].posX;
					var py:Number = Main.clientManager.clients[p].posY;
					
					for (var cl:int = collectableList.length - 1; cl > -1; cl-- )
					{
						if (collectableList[cl].checkCollision(px, py))
						{
							if (Main.clientManager.clients[p].size < 9)
							{
								Main.clientManager.clients[p].size++;
								Main.clientManager.sendMessageToClient(NetworkID.SERVER_SIZE, "" + Main.clientManager.clients[p].size, Main.clientManager.clients[p].playerID);
								Main.clientManager.sendMessageToAll(NetworkID.SERVER_COLDESTROY, "" + collectableList[cl].id);
							}
							collectableList.splice(cl, 1);
						}
					}
				}
				
				if (Main.clientManager.clients.length < 2)
				{
					end();
					return;
				}
				
				for (var p2:int = 0; p2 < Main.clientManager.clients.length; p2++ )
				{
					var px2:Number = Main.clientManager.clients[p2].posX;
					var py2:Number = Main.clientManager.clients[p2].posY;
					
					//if (Main.clientManager.clients[p2].hitcooldown > 0)
					//{
					//	Main.clientManager.clients[p2].hitcooldown--;
					//}
					
					for (var e:int = 0; e < Main.clientManager.clients.length; e++ )
					{
						if (p2 != e)
						{
							//if (Main.clientManager.clients[p2].hitcooldown == 0 && (Main.playerManager.clients[e] as Player).hitcooldown == 0)
							//{
								if (MathHelper.dis2(px2, py2, Main.clientManager.clients[e].posX, Main.clientManager.clients[e].posY) < 80)
								{
									if (Main.clientManager.clients[p2].size > Main.clientManager.clients[e].size)
									{
										if (Main.clientManager.clients[p2].size < 9)
										{
											Main.clientManager.clients[p2].size++;
										}
										
										var randomX:int = 100 + MathHelper.nextInt(1400);
										var randomY:int = 100 + MathHelper.nextInt(1400);
										
										//Main.clientManager.clients[p2].hitcooldown = 30;
										Main.clientManager.sendMessageToClient(NetworkID.SERVER_SIZE, "" + Main.clientManager.clients[p2].size, Main.clientManager.clients[p2].playerID);
										Main.clientManager.sendMessageToClient(NetworkID.SERVER_SIZE, "" + 1, Main.clientManager.clients[e].playerID);
										Main.clientManager.sendMessageToClient(NetworkID.SERVER_DEATH, "" + Main.clientManager.clients[p2].playerID, Main.clientManager.clients[e].playerID);
										Main.clientManager.sendMessageToClient(NetworkID.SERVER_KILL, "" + Main.clientManager.clients[e].playerID, Main.clientManager.clients[p2].playerID);
										Main.clientManager.sendMessageToClient(NetworkID.SERVER_SPAWN, randomX + "&" + randomY, Main.clientManager.clients[e].playerID);
										Main.clientManager.sendMessageToAll(NetworkID.SERVER_MESSAGE, Main.clientManager.clients[p2].playerName + " ate " + Main.clientManager.clients[e].playerName);
										Main.clientManager.clients[e].posX = randomX;
										Main.clientManager.clients[e].posY = randomY;
										Main.clientManager.clients[e].size = 1;
										//Main.clientManager.clients[e].hitcooldown = 30;
									}
								}
							//}
						}
					}
				}
			}
			else
			{
				timer_ready--;
				if (timer_ready < 0)
				{
					if (readyCheck() || timer_wait > 30 * 30)
					{
						start();
					}
				}
			}
		}
		
		public function start():void
		{
			ServerLog.addMessage("GAME", "Starting game...");
			
			GameState.LOBBY = false;
			GameState.PLAYING = true;
			
			timer_pos = 30;
			timer_col = 120;
			timeLeft = 5 * 60;
			frameLeft = 30;
			
			collectableList = new Vector.<Collectable>();
			nextcolID = 0;
						
			//SPAWN ALL PLAYERS
			var xxx:int = 50;
			var yyy:int = 0;
			
			for (var p:int = Main.clientManager.clients.length - 1; p > -1; p--)
			{
				Main.clientManager.sendMessageToClient(NetworkID.SERVER_START, Main.clientManager.clients.length + "&" + "5" + Main.clientManager.clients[p].playerID + "&" + (p * xxx + 0) + "&" + yyy, Main.clientManager.clients[p].playerID);	
				Main.clientManager.clients[p].posX = (p * xxx + 0);
				Main.clientManager.clients[p].posY = yyy;
				Main.clientManager.clients[p].size = 1;
			}
			
			ServerLog.addMessage("GAME", "Game started!");
		}
		
		public function end():void
		{
			ServerLog.addMessage("GAME", "Ending game...");
			
			//CHANGE GAMESTATE
			GameState.LOBBY = true;
			GameState.PLAYING = false;
			
			//SET TIMERS
			timer_ready = 300;
			
			//SEND ENDING
			Main.clientManager.sendMessageToAll(NetworkID.SERVER_END, "");
			
			ServerLog.addMessage("GAME", "Game Ended!");
		}
		
		public function readyCheck():Boolean
		{
			//timer_wait++;
			
			if (Main.clientManager.clients.length < 2)// Settings.MAX_PLAYERS)
			{
				return false;
			}
			
			for (var i:int = Main.clientManager.clients.length - 1; i > -1; i-- )
			{
				if (!Main.clientManager.clients[i].ready)
				{
					return false;
				}
			}
			
			return true;
		}
	}
}