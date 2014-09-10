package net.ted80.MetalbugsClient.input 
{
	import flash.events.MouseEvent;
	import net.ted80.MetalbugsClient.Main;
	
	public class InputMouse 
	{
		public static var mouseX:int;
		public static var mouseY:int;
		public static var mouseDown:Boolean;
		
		public function onMouseDown(e:MouseEvent):void
		{
			mouseDown = true;
			Main.gui.checkButtons(mouseX, mouseY);
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			mouseDown = false;
		}
		
		public function onMouseMove(e:MouseEvent):void
		{
			mouseX = e.stageX;
			mouseY = e.stageY;
			Main.gui.checkHover(mouseX, mouseY);
		}
		
		public function onMouseScroll(e:MouseEvent):void 
		{
			Main.gui.scroll(e.delta);
		}
	}
}