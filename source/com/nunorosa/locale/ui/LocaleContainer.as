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

package com.nunorosa.locale.ui 
{
	import com.nunorosa.locale.*;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LocaleContainer extends Sprite implements ILocaleComponent
	{
		private var _localeManager:LocaleManager;
		public function get localeManager():LocaleManager { return _localeManager; }
		
		private var localeComponents:Array;
		
		private var _id:String;
		public function get localeID():String { return _id; }
		public function set localeID(value:String):void { _id = value; }
		
		private var _section:String;
		public function get localeSection():String { return _section; }
		public function set localeSection(value:String):void { _section = value; }
		
		public function LocaleContainer() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			localeComponents = [];
			_localeManager = LocaleManager.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		protected function addedHandler(e:Event):void 
		{
			if(!(this.parent is ILocaleComponent))
				_localeManager.registerComponent(this);
		}
		
		protected function removeHandler(e:Event):void 
		{
			_localeManager.unregisterComponent(this);
		}
		
		protected function addLocaleComponent(c:ILocaleComponent):Boolean
		{
			var length:uint = localeComponents.length;
			for (var i:uint = 0; i < length; i++)
				if (localeComponents[i] == c)	return false;
				
			localeComponents.push(c);
			
			return true;
		}
		
		protected function removeLocaleComponent(c:ILocaleComponent):Boolean
		{
			var length:uint = this.localeComponents.length;
			for (var i:int = 0; i < length; i++)
			{
				if (localeComponents[i] == c)
				{
					localeComponents.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			if (child is ILocaleComponent)
				addLocaleComponent(child as ILocaleComponent);
				
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			if (child is ILocaleComponent)
				addLocaleComponent(child as ILocaleComponent);
				
			return super.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			if (child is ILocaleComponent)
				removeLocaleComponent(child as ILocaleComponent);
					
				
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			var child:DisplayObject = getChildAt(index);
			if (child is ILocaleComponent)
				removeLocaleComponent(child as ILocaleComponent);
				
			return super.removeChildAt(index);
		}
		
		//AbstractLocaleComponent implementation
		public function updateLanguage():void 
		{
			for each(var c:ILocaleComponent in localeComponents)
			{
				c.updateLanguage();
			}
		}
	}
}