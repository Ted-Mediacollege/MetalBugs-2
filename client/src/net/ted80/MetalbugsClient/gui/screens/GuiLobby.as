package net.ted80.MetalbugsClient.gui.screens 
{
	import net.ted80.MetalbugsClient.gui.GuiScreen;
	import net.ted80.MetalbugsClient.gui.components.GuiButton;
	import net.ted80.MetalbugsClient.gui.components.GuiText;
	import net.ted80.MetalbugsClient.Main;
	
	public class GuiLobby extends GuiScreen
	{
		public static var started:Boolean = false;
		public static var spawnX:int = 0;
		public static var spawnY:int = 0;
		
		public function GuiLobby() 
		{
		}
		
		override public function init():void
		{
			buttonList = new Vector.<GuiButton>();
			
			started = false;
			
			var temp:GuiText = new GuiText(Main.CenterWidth, Main.CenterHeight, 25, 0xFFFFFF, "center");
			temp.setText("Waiting for other players to connect!");
			addChild(temp);
		}
		
		override public function tick():void
		{
			if (started)
			{
				main.switchGui(new GuiGame(spawnX, spawnY));
			}
		}
		
		override public function action(id:int):void
		{
			
		}
	}
}