package net.ted80.MetalbugsClient.network 
{
	public class NetworkID 
	{
		//CLIENT -> SERVER
		//nID#xpos&ypos&dir&speed&size&flash
		public static var CLIENT_WELCOME:int = 0; //send client name to server
		
		//SERVER -> CLIENT
		//pID#xpos&ypos&dir&speed&size&flash
		public static var SERVER_REJECT:int = 0; //reject client
		public static var SERVER_WELCOME:int = 1; //welcome client and send playerID, networkID
		public static var SERVER_JOIN:int = 2; //client joins message
		public static var SERVER_LEAVE:int = 3; //client leaves message
		public static var SERVER_MESSAGE:int = 4; //server message to clients
		
		public static var SERVER_START:int = 10; //match starts
		public static var SERVER_END:int = 11; //match ends
		
		public static var SERVER_SPAWN:int = 20; //inform client spawn
		public static var SERVER_SIZE:int = 21; //inform client grow
		public static var SERVER_KILL:int = 22; //inform client killed
		public static var SERVER_DEATH:int = 23; //inform client dead
		
		public static var SERVER_COLSPAWN:int = 30; //on collecteble spawned
		public static var SERVER_COLDESTROY:int = 31; //on collecteble destroyed
		
		
		//REJECT REASON
		public static var REJECT_FULL:int = 0; //reject client because full
		public static var REJECT_PLAYING:int = 1; //reject client because playing
	}
}