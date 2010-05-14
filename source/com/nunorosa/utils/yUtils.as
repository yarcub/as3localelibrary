package com.nunorosa.utils 
{
	import flash.text.TextField;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	public class yUtils 
	{
		
		public function yUtils() { }
		
		public static function scrambleText(tf:TextField, message:String = undefined):void {
			if (!message) message = tf.text;
			var t1:String = "";
			var t2:String = "";
			var t3:String = "";
			var index:Number = 0;
			var textInt:Number = setInterval(composeString, 20);
			
			// KLUDGE - shouldn't have a function inside a method, but fuck it...
			function composeString():void {
				if ((++index) <= message.length){
					t1 = "";
					t2 = message.substr (0, index);
					t3 = message.substr (index);
					var len:Number = t3.length;
					for (var i:int = 0; i < len; i++) {
							t1 += String.fromCharCode (String("a").charCodeAt(0) + Math.round(Math.random() * 26));
					}
					tf.text = t2 + t1;
				} else {
					clearInterval(textInt);
				}
			}
		}
		
	}
	
}