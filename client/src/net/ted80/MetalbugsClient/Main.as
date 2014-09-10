package net.ted80.MetalbugsClient 
{
	import flash.display.Sprite;
	import net.ted80.MetalbugsClient.gui.screens.GuiLogin;
	import net.ted80.MetalbugsClient.network.Connection;
	import flash.events.Event;
	import net.ted80.MetalbugsClient.gui.GuiScreen;
	import flash.utils.ByteArray;
	import net.ted80.MetalbugsClient.input.InputMouse;
	import net.ted80.MetalbugsClient.input.InputKey;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class Main extends Sprite
	{		
		public static var ScreenWidth:int;
		public static var ScreenHeight:int;
		public static var CenterWidth:int;
		public static var CenterHeight:int;
		
		public static var gui:GuiScreen;
		public static var connection:Connection;
		
		public var mouse:InputMouse;
		public var key:InputKey;
		
		public function Main() 
		{
			connection = new Connection();
			
			ScreenWidth = stage.stageWidth;
			ScreenHeight = stage.stageHeight;
			CenterWidth = ScreenWidth / 2;
			CenterHeight = ScreenHeight / 2;
			
			switchGui(new GuiLogin());
			
			//mouse events
			mouse = new InputMouse();
			addEventListener(MouseEvent.MOUSE_MOVE, mouse.onMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, mouse.onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouse.onMouseUp);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouse.onMouseScroll);
			
			//key events
			key = new InputKey();
			addEventListener(KeyboardEvent.KEY_DOWN, key.onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, key.onKeyUp);
			
			addEventListener(Event.ENTER_FRAME, tick);
		}
		
		public function tick(e:Event):void
		{
			gui.tick();
			//var ba:ByteArray = new ByteArray();
			//ba.writeUTF("test");
			//connection.socketUDP.send(ba, 0, 0, connection.serverIP, connection.serverPORT + 1);
			//trace("sending...");
		}
		
		public function switchGui(g:GuiScreen):void
		{
			if (gui != null)
			{
				removeChild(gui);
			}
			gui = g;
			addChildAt(gui, 0);
			gui.preInit(this);
			gui.init();
		}
	}
}