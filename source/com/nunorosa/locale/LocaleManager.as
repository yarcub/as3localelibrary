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

package com.nunorosa.locale 
{
	import com.nunorosa.locale.events.LocaleEvent;
	import com.nunorosa.locale.ui.ILocaleComponent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	/**
	 * The com.nunorosa.locale.LocaleManager class allows you to easealy manage multilanguage applications.
	 * 
	 * <p>It's works similar to the <a href="http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/fl/lang/package-detail.html">fl.lang</a> package but with a singleton pattern instead a static class, for example the language file (XML) must also use the XML Localization Interchange File Format (XLIFF).</p>
	 *
	 * @see http://en.wikipedia.org/wiki/Singleton_pattern Singleton Pattern
	 */
	public class LocaleManager extends EventDispatcher
	{	
		static private var _instance:LocaleManager;
		
		private var components:Array;
		private var currentLang:XML;
		private var languageCodeArray:Array;
		private var loader:URLLoader;
		
		private var _autoUpdate:Boolean;
		/**
		 * Determines whether registered components are notified after loading XML file.
		 * 
		 * @default true
		 */
		public function set autoUpdate(value:Boolean):void { _autoUpdate = value; }
		/**
		 * @private
		 */
		public function get autoUpdate():Boolean { return _autoUpdate; }
		
		private var _language:String;
		/**
		 * Returns the current language code.
		 * 
		 * <p>When the instance is created this property has the system default value.<br>
		 * System languages codes can be seen in the <a href="http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/system/Capabilities.html#language">flash.system.Capabilities</a> documentation.</p>
		 */
		public function get language():String { return _language;}
		
		/**
		 * This class implements the singleton pattern, can't be instantiated with the <b>new</b> keyword.
		 * 
		 * @private
		 * @param
		 */
		public function LocaleManager(singletonEnforcer:SingletonEnforcer) 
		{
			components = [];
			languageCodeArray = [];
			_autoUpdate = true;
			//_language = Capabilities.language;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
			
		private function securityErrorHandler(e:SecurityErrorEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
		private function progressHandler(e:ProgressEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
		private function openHandler(e:Event):void 
		{
			dispatchEvent(new LocaleEvent(LocaleEvent.OPEN,_language));
		}
		
		private function completeHandler(e:Event):void 
		{
			currentLang = new XML(e.target.data);
			dispatchEvent(new LocaleEvent(LocaleEvent.COMPLETE,_language));
			if(_autoUpdate)
				notifyComponents();
		}
		
		/**
		 * Instantiates and/or returns the reference to the LocaleManager instance.
		 * 
		 * @example how to get a reference to the LocalManager
		 * <listing version="3.0" >
		 * var locale:LocalManager = LocalManager.getInstance();
		 * trace(locale.autoUpdate); //true
		 * </listing>
		 * @return LocaleManager instance reference.
		 */
		public static function getInstance():LocaleManager {
			if(LocaleManager._instance == null) {
				LocaleManager._instance = new LocaleManager(new SingletonEnforcer());
			}
			return LocaleManager._instance;
		}
		
		/**
		 * Register a multilanguage component to be notified when the language is changed.
		 * 
		 * @param	c The component, i.e., any object implementing the ILocaleComponent interface.
		 * @return
		 * @see com.nunorosa.locale.ui.ILocaleComponent
		 */
		public function registerComponent(c:ILocaleComponent):Boolean
		{
			var length:uint = components.length;
			for (var i:uint = 0; i < length; i++)
				if (components[i] == c)	return false;
				
			components.push(c);
			return true;
		}
		
		/**
		 * Unregister a multilanguage component to stop receiving language notifications.
		 * 
		 * @param	c	The component, i.e., any object implementing the ILocaleComponent interface.
		 * @return
		 * @see com.nunorosa.locale.ui.ILocaleComponent
		 */
		public function unregisterComponent(c:ILocaleComponent):Boolean
		{
			var length:uint = components.length;
			for (var i:uint = 0; i < length; i++)
			{
				if (components[i] == c)
				{
					components.splice(i, 1);
					return true
				}
			}
			return false;
		}
		
		public function isRegistered(c:ILocaleComponent):Boolean
		{
			var length:uint = components.length;
			for (var i:uint = 0; i < length; i++)
			{
				if (ILocaleComponent(components[i]) == c)
					return true
			}
			return false;
		}
		/**
		 * Use this method to load the default system language.
		 * 
		 * <b>Note:</b> Make sure you associate a language file (XML) with the correct language code.
		 * @example
		 * <listing version="3.0" >
		 * var locale:LocaleManager = LocaleManager.getInstance();
		 * locale.addXMLPath("en","langFile_en.xml");
		 * locale.initialize();
		 * </listing>
		 * @see #addXMLPath()
		 * @see http://livedocs.adobe.com/flex/201/langref/flash/system/Capabilities.html#language System language codes
		 */
		public function initialize():void
		{
			_language = Capabilities.language;
			
			var index:int = getIndex(_language);
			if (index != -1)
			{
				loader.load(new URLRequest(languageCodeArray[index].path));
			}else
			{
				dispatchEvent(new LocaleEvent(LocaleEvent.ERROR,_language));
			}
		}
		
		/**
		 * Load the XML file corresponding to the language code.
		 * 
		 * @param	langCode The language code.
		 * @see #addXMLPath()
		 * @example
		 * <listing version="3.0" >
		 * LocalManager.getInstance().setLang("pt");
		 * </listing>
		 */
		public function setLang(langCode:String):void
		{
			var index:int = getIndex(langCode);
			if (index != -1)
			{
				_language = langCode;
				loader.load(new URLRequest(languageCodeArray[index].path));
				
				dispatchEvent(new LocaleEvent(LocaleEvent.CHANGE,_language));
			}else
			{
				dispatchEvent(new LocaleEvent(LocaleEvent.ERROR,langCode));
			}
		}
		
		/**
		 *Returns the string value associated with the given string ID in the current language.
		 * 
		 * @param	id 		ID defined in the XML file.
		 * @param	section	the node name in the XML file.
		 * @return
		 */
		public function getString(id:String,section:String):String
		{
			var str:String = "Warning: no language file loaded yet!";
			if (currentLang != null)
			{
				try{
					str = currentLang[section].*.(@id == id).text();
				}catch (e:ReferenceError)
				{
					str = "Error, invalid id or section";
				}
				
				if (str == "")
					str = "Error, invalid id or section";
			}	
			
			return str;
		}
		
		/**
		 * Adds the {languageCode and languagePath} pair into the internal array for later use.
		 * 
		 * @param	langCode	The language code.
		 * @param	path		The XML path to add. 
		 */
		public function addXMLPath(langCode:String, path:String):void
		{
			var length:uint = languageCodeArray.length;
			for (var i:uint = 0; i < length; i++)
			{
				if (languageCodeArray[i].langCode == langCode || languageCodeArray[i].path == path)
				{
					languageCodeArray[i] = { langCode:langCode, path:path };
					break;
				}
			}
			languageCodeArray.push( { langCode:langCode, path:path } );
		}
		
		/**
		 * Checks if exists a xml file assigned to the language code
		 * 
		 * @param	langCode	The language code.
		 * @return	true if there is a xml file assigned with langCode
		 */
		public function isLangSupported(langCode:String):Boolean
		{
			var length:uint = languageCodeArray.length;
			
			for (var i:uint = 0; i < length; i++)
			{
				if(languageCodeArray[i].langCode == langCode)
					return true;
			}

			return	false;
		}
		
		/**
		 * Return all supported language codes (added with addXMLPath method)
		 * 
		 * @return an array like [{label:pt},{label:en},{label:fr}], usefull to populate ui components
		 */
		public function getLangCodes():Array
		{
			var list:Array = [];
			for (var i:uint = 0 ; i < this.languageCodeArray.length; i++)
			{
				list.push( { label:languageCodeArray[i].langCode } );
			}
			
			return list;
		}
		
		private function notifyComponents():void
		{
			for each(var c:ILocaleComponent in components)
			{
				c.updateLanguage();
			}
			dispatchEvent(new LocaleEvent(LocaleEvent.FINISH, _language));
		}

		private function getIndex(langCode:String):int
		{
			var index:int = -1;
			var length:uint = languageCodeArray.length;
			for (var i:uint = 0; i < length; i++)
			{
				if (languageCodeArray[i].langCode == langCode)
				{
					index = i;
					break;
				}
			}
			return index;
		}
	}
	
}

class SingletonEnforcer {}