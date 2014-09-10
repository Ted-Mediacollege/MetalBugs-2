package net.ted80.MetalbugsClient.gui.screens 
{
	import net.ted80.MetalbugsClient.gui.GuiScreen;
	import net.ted80.MetalbugsClient.gui.components.GuiText;
	import net.ted80.MetalbugsClient.network.NetworkID;
	import net.ted80.MetalbugsClient.Main;
	import net.ted80.MetalbugsClient.gui.components.GuiButton;
	import net.ted80.MetalbugsClient.util.MathHelper;
	
	public class GuiConnecting extends GuiScreen
	{
		public static var text_status:GuiText;
		public var fallbacktimer:int = -2;
		
		public function GuiConnecting() 
		{
		}
		
		override public function init():void
		{
			buttonList = new Vector.<GuiButton>();
			
			Main.connection.connect();
			
			text_status = new GuiText(Main.CenterWidth, Main.CenterHeight, 25, 0xFFFFFF, "center");
			text_status.setText("Connecting...");
			addChild(text_status);
		}
		
		override public function tick():void
		{
			if (fallbacktimer > 0)
			{
				fallbacktimer--;
				if (fallbacktimer == 0)
				{
					main.switchGui(new GuiLogin());
				}
			}
			
			if (Main.connection.failed && fallbacktimer < 0)
			{
				text_status.setText("Unable to connect!");
				fallbacktimer = 50;
			}
			else if (Main.connection.connected)
			{
				main.switchGui(new GuiLobby());
			}
		}
		
		override public function action(id:int):void
		{
			
		}
	}
}