package net.ted80.MetalbugsClient.gui.screens 
{
	import net.ted80.MetalbugsClient.gui.GuiScreen;
	import net.ted80.MetalbugsClient.gui.components.GuiButton;
	import net.ted80.MetalbugsClient.gui.components.GuiText;
	import net.ted80.MetalbugsClient.Main;
	
	public class GuiLobby extends GuiScreen
	{
		public function GuiLobby() 
		{
		}
		
		override public function init():void
		{
			buttonList = new Vector.<GuiButton>();
			
			var temp:GuiText = new GuiText(Main.CenterWidth, Main.CenterHeight, 25, 0xFFFFFF, "center");
			temp.setText("Waiting for other players to connect!");
			addChild(temp);
		}
		
		override public function tick():void
		{
			/*
			Main.connection.tick();
			
			if (started)
			{
				//engine.switchGui(new GuiGame(spawnX, spawnY));
			}
			*/
		}
		
		override public function action(id:int):void
		{
			
		}
	}
}