package net.ted80.MetalbugsClient.input 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import net.ted80.MetalbugsClient.Main;
	
	public class InputKey 
	{
		public static var keyList:Vector.<int> = new Vector.<int>();
		public static var downArray:Vector.<Boolean> = new Vector.<Boolean>();
		
		public static function addKey(key:int):int
		{
			keyList.push(key);
			downArray.push(false);
			return keyList.length - 1;
		}
		
		public static function setKey(arraypos:int, newkey:int):void
		{
			keyList[arraypos] = newkey;
			downArray[arraypos] = false;
		}
		
		public static function isKeyDown(arraypos:int):Boolean
		{
			return downArray[arraypos];
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			Main.gui.onKeyPress(e.keyCode);
			
			for (var i:int = 0; i < keyList.length; i++ )
			{
				if (e.keyCode == keyList[i])
				{
					downArray[i] = true;
				}
			}
		}
		
		public function onKeyUp(e:KeyboardEvent):void
		{
			for (var i:int = 0; i < keyList.length; i++ )
			{
				if (e.keyCode == keyList[i])
				{
					downArray[i] = false;
				}
			}
		}
	}
}