package net.ted80.MetalbugsClient.world 
{
	import flash.display.MovieClip;
	import net.ted80.MetalbugsClient.Main;
	
	public class Collectable extends MovieClip
	{
		public var PosX:Number;
		public var PosY:Number;
		public var Art:MovieClip;
		public var IdCollectable:int;
		
		public function Collectable(Id:int,PositionX:Number, PosistionY:Number)
		{
			IdCollectable = Id;
			PosX = PositionX;
			PosY = PosistionY;
			Art = new Collectable1();
			addChild(Art);
			Art.x = -Level.players.player.PosX + PosX + Main.CenterWidth;
			Art.y = -Level.players.player.PosY + PosY + Main.CenterHeight;
		}
		
		public function loop():void
		{
			Art.x = -Level.players.player.PosX + PosX + Main.CenterWidth;
			Art.y = -Level.players.player.PosY + PosY + Main.CenterHeight;
		}
	}
}