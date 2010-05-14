/**
Copyright (c) 2008 Nuno Rosa, http://www.nunorosa.com

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package src 
{
	import com.nunorosa.locale.LocaleManager;
	import com.nunorosa.locale.ui.ILocaleComponent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Nuno Rosa (nuno.sp.rosa@gmail.com)
	 */
	public class CustomAsset extends Sprite implements ILocaleComponent
	{
		private var _localeID:String;
		private var _localeSection:String;
		
		private var tf:TextField;
		
		public function CustomAsset() 
		{
			init();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function init():void
		{
			tf = new TextField();
			tf.multiline 			= 	false;
			tf.autoSize 			=	TextFieldAutoSize.LEFT;
			tf.defaultTextFormat 	=	new TextFormat("Arial", 12, 0x000000);
			addChild(tf);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			updateLanguage();
		}
		
		/* INTERFACE com.nunorosa.locale.ui.ILocaleComponent */
		
		public function updateLanguage():void
		{
			tf.text = LocaleManager.getInstance().getString( localeID, localeSection);
			
			trace("Asset(" + localeID +"/" + localeSection + ") was notified.");
		}
		
		public function get localeID():String { return _localeID; }
		
		public function set localeID(value:String):void 
		{
			_localeID = value;
		}
		
		public function get localeSection():String { return _localeSection; }
		
		public function set localeSection(value:String):void 
		{
			_localeSection = value;
		}
		
	}
	
}