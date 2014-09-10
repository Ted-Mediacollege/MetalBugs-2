package net.ted80.MetalbugsServer.gui 
{
	import flash.display.Sprite;
	import net.ted80.MetalbugsServer.data.ServerLog;
	
	public class GuiLog extends Sprite
	{
		public var textfields:Vector.<GuiLogText>;
		public var logCount:int = 0;
		
		public function GuiLog() 
		{
			textfields = new Vector.<GuiLogText>(30);
			for (var i:int = 0; i < 30; i++ )
			{
				textfields[i] = new GuiLogText(10, 10 + (i * 18), 15, 0x000000, "left");
				addChild(textfields[i]);
			}
		}
		
		public function tick():void
		{
			if (ServerLog.logCount != logCount)
			{
				logCount = ServerLog.logCount;
				
				var l:int = ServerLog.log.length;
				for (var i:int = 0; i < 30; i++ )
				{
					if (i < l)
					{
						textfields[i].setText(ServerLog.log[i]);
					}
					else 
					{
						textfields[i].setText("");
					}
				}
			}
		}
	}
}