package net.ted80.MetalbugsServer 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.ted80.MetalbugsServer.data.ServerLog;
	import net.ted80.MetalbugsServer.gui.GuiLog;
	import net.ted80.MetalbugsServer.network.client.ClientManager;
	import net.ted80.MetalbugsServer.network.policy.PolicyManager;
	import net.ted80.MetalbugsServer.data.GameState;
	import net.ted80.MetalbugsServer.world.World;

	public class Main extends Sprite
	{
		public static var policyManager:PolicyManager;
		public static var clientManager:ClientManager;
		public static var world:World;
		
		public var log:GuiLog;
		
		public function Main() 
		{
			restartServer();
			
			log = new GuiLog();
			addChild(log);
			
			addEventListener(Event.ENTER_FRAME, tick);
		}
		
		public function restartServer():void
		{
			ServerLog.addMessage("SERVER", "Restarting server...");
			
			GameState.LOBBY = true;
			GameState.PLAYING = false;
			
			//POLICY MANAGER
			if (policyManager != null) { policyManager.destroy(); }
			policyManager = new PolicyManager();
			
			//CLIENT MANAGER
			if (clientManager != null) { clientManager.destroy(); }
			clientManager = new ClientManager();
			
			//WORLD
			if (world != null) { world = null; }
			world = new World();
			
			ServerLog.addMessage("SERVER", "Server is ready!");
		}
		
		public function tick(e:Event):void
		{
			log.tick();
			clientManager.tick();
			world.tick();
		}
	}
}