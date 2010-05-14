package com.nunorosa.locale.events 
{
	import flash.events.Event;
	
	public class LocaleEvent extends Event 
	{
		public static const COMPLETE:String	= 	"localeComplete";
		public static const OPEN:String 	=	"localeOpen";
		public static const FINISH:String 	=	"localeFinish";
		public static const ERROR:String	=	"localeError";
		public static const CHANGE:String	=	"localeChange";
		
		public var langCode:String;
			
		public function LocaleEvent(type:String, lang:String , bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			langCode = lang;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LocaleEvent(type, langCode, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LocaleEvent", "type","langCode", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}