package net.ted80.MetalbugsClient.gui 
{
	import flash.display.Sprite;
	import net.ted80.MetalbugsClient.gui.components.GuiButton;
	import net.ted80.MetalbugsClient.Main;
	
	public class GuiScreen extends Sprite
	{
		protected var main:Main;
		public var buttonList:Vector.<GuiButton>;
		
		public function init():void { }
		public function tick():void { }
		public function unFocus():void { }
		public function action(id:int):void { }
		public function scroll(delta:int):void { }
		public function onKeyPress(key:int):void { }
		
		public function preInit(m:Main):void
		{
			main = m;
		}
		
		public function checkButtons(posX:int, posY:int):void
		{
			for (var i:int = 0; i < buttonList.length; i++ )
			{
				if (posX > buttonList[i].posX &&
					posY > buttonList[i].posY && 
					posX < buttonList[i].posX + buttonList[i].box[0] && 
					posY < buttonList[i].posY + buttonList[i].box[1] )
				{
					action(buttonList[i].id);
					break;
				}
			}
		}
		
		public function checkHover(posX:int, posY:int):void
		{
			for (var i:int = 0; i < buttonList.length; i++ )
			{
				if (posX > buttonList[i].posX &&
					posY > buttonList[i].posY && 
					posX < buttonList[i].posX + buttonList[i].box[0] && 
					posY < buttonList[i].posY + buttonList[i].box[1] )
				{
					buttonList[i].hover(true);
				}
				else
				{
					buttonList[i].hover(false);
				}
			}
		}
	}
}