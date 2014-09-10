package net.ted80.MetalbugsServer.data 
{
	public class ServerLog 
	{
		public static var log:Vector.<String> = new Vector.<String>();
		private static var length:int = 0;
		public static var logCount:int = 0;
		
		public static function addMessage(subject:String, message:String):void
		{
			var date:Date = new Date();
			var d:Vector.<int> = new <int>[date.getHours(), date.getMinutes(), date.getSeconds()];
			var s:String = "[";
			for (var i:int = 0; i < 3; i++ )
			{
				s += (d[i] < 10 ? "0" : "") + d[i] + (i < 2 ? ":" : "]");
			}
			
			s += "[" + subject + "]: " + message;
			log.push(s);
			trace(s);
			
			logCount++;
			length++;
			if (length > 30)
			{
				length--;
				log.shift();
			}
		}
	}
}