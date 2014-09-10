package net.ted80.MetalbugsClient.gui.screens 
{
	import net.ted80.MetalbugsClient.gui.GuiScreen;
	import net.ted80.MetalbugsClient.gui.components.GuiText;
	import net.ted80.MetalbugsClient.gui.components.GuiButton;
	import net.ted80.MetalbugsClient.gui.components.GuiTextInput;
	import net.ted80.MetalbugsClient.Main;
	import net.ted80.MetalbugsClient.network.Connection;
	
	public class GuiLogin extends GuiScreen
	{
		public var inputfield1:GuiTextInput;
		public var inputfield2:GuiTextInput;
		public var inputfield3:GuiTextInput;
			
		public function GuiLogin() 
		{
		}
		
		override public function init():void
		{
			buttonList = new Vector.<GuiButton>();
			
			var text_input1:GuiText = new GuiText(-180, 280, 20, 0xFFFFFF, "right");
			var text_input2:GuiText = new GuiText(-180, 340, 20, 0xFFFFFF, "right");
			var text_input3:GuiText = new GuiText(-180, 400, 20, 0xFFFFFF, "right");
			
			text_input1.setText("Your name:");
			text_input2.setText("IP:");
			text_input3.setText("PORT:");
			
			addChild(text_input1);
			addChild(text_input2);
			addChild(text_input3);
			
			inputfield1 = new GuiTextInput(630, 280, 20, 0xFFFFFF, "left", 15, "A-Za-z0-9");
			inputfield2 = new GuiTextInput(630, 340, 20, 0xFFFFFF, "left", 20, "0-9.");
			inputfield3 = new GuiTextInput(630, 400, 20, 0xFFFFFF, "left", 5, "0-9");
			
			inputfield1.setText(Main.connection.playerName);
			inputfield2.setText(Main.connection.serverIP);
			inputfield3.setText(Main.connection.serverPORT + "");
			
			addChild(inputfield1);
			addChild(inputfield2);
			addChild(inputfield3);
			
			var button_connect:GuiButton = new GuiButton(0, Main.CenterWidth - 100, Main.ScreenHeight - 200, 30, 200);
			button_connect.setText("Connect", 20, 0xFFFFFF);
			addChild(button_connect);
			buttonList.push(button_connect);
		}
		
		override public function tick():void
		{
		}
		
		override public function action(id:int):void
		{
			if (id == 0)
			{
				Main.connection.serverIP = inputfield2.tf.text;
				Main.connection.serverPORT = parseInt(inputfield3.tf.text);
				Main.connection.playerName = inputfield1.tf.text;
				main.switchGui(new GuiConnecting());
			}
		}
	}
}