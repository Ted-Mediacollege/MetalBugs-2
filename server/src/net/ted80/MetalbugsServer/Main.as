package net.ted80.MetalbugsServer 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.ted80.MetalbugsServer.data.ServerLog;
	import net.ted80.MetalbugsServer.gui.GuiLog;
	import net.ted80.MetalbugsServer.network.policy.PolicyManager;

	public class Main extends Sprite
	{
		public var policyManager:PolicyManager;
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
			
			//POLICY MANAGER
			if (policyManager != null) { policyManager.destroy(); }
			policyManager = new PolicyManager();
		}
		
		public function tick(e:Event):void
		{
			log.tick();
		}
	}
}