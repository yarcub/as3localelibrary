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
package	src
{
	import adobe.utils.ProductManager;
	import com.nunorosa.locale.LocaleManager;
	import com.nunorosa.locale.events.LocaleEvent;
	import com.nunorosa.locale.ui.ILocaleComponent;
	import com.nunorosa.locale.ui.LocaleContainer;
	import fl.controls.ComboBox;
	import fl.controls.NumericStepper;
	import fl.controls.TextInput;
	import fl.data.DataProvider;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	import fl.controls.Button;
	import fl.controls.Label;
	import flash.system.Capabilities;
	
	/**
	 *
	 * @author Nuno Rosa (nuno.sp.rosa@gmail.com)
	 */
	public class Main extends LocaleContainer
	{	
		private var btn:Button;
		private var rmBtn:Button;
		private var idInput:TextInput;
		private var sInput:TextInput;
		private var cBox:ComboBox;
		
		private var nextY:int	=	100;
		
		public function Main() 
		{
			initUI();
			initLocale();
		}
		
		private function initUI():void
		{
			btn			=	Button(this["bt"]);
			rmBtn		=	Button(this["rm"]);
			idInput		=	TextInput(this["inputA"]);
			sInput		=	TextInput(this["inputB"]);
			cBox		=	ComboBox(this["drop"]);
			
			rmBtn.enabled 	= false;
			
			btn.addEventListener(MouseEvent.CLICK,	addAsset);
			rmBtn.addEventListener(MouseEvent.CLICK, rmAsset);
			cBox.addEventListener(Event.CHANGE,		onChange);
		}

		private function addAsset(e:MouseEvent):void 
		{
			var asset:CustomAsset	=	new CustomAsset();
			asset.localeID			=	idInput.text;
			asset.localeSection		=	sInput.text;
			
			asset.x					=	idInput.x;
			asset.y					=	nextY;
			
			addChild(asset);
			nextY	+=	asset.height;
			
			if(!btn.enabled)
				btn.enabled = true;
		}
		
		private function rmAsset(e:MouseEvent):void 
		{
			var id:String 	=	idInput.text
			var s:String	=	sInput.text;
			
			var res:Boolean = 	removeAsset(id, s);
			
			trace("Trying to remove asset (" + id + "/" + s + ") : "+ res);
			
			rearrangeItems();
		}
		
		private function onChange(e:Event):void
		{
			localeManager.setLang(cBox.selectedItem.data);
		}
		
		private function initLocale():void 
		{
			localeManager.addEventListener(LocaleEvent.ERROR,	 onLocaleError);
			localeManager.addEventListener(LocaleEvent.CHANGE,	 onLocaleChange);
			localeManager.addEventListener(LocaleEvent.OPEN,	 onLocaleOpen);
			localeManager.addEventListener(LocaleEvent.COMPLETE, onLocaleComplete);
			localeManager.addEventListener(LocaleEvent.FINISH,   onLocaleFinish);
			localeManager.addXMLPath("pt","langFiles/lang_pt.xml");
			localeManager.addXMLPath("en","langFiles/lang_en.xml");

			/*
			 * see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/system/Capabilities.html#language
			 * for expected language codes
			 * 
			 * or call localeManager.initialize() and the system default will be loaded, but no check is made before.
			 * localeManager.isLangSupported checks is there is a XML file assigned to the specific language code.
			 */
			var langCode:String	=	localeManager.isLangSupported(Capabilities.language) ? Capabilities.language : "en"; 
			localeManager.setLang(langCode);
		}
		
		override public function updateLanguage():void 
		{
			super.updateLanguage();
			
			btn.label			= 	localeManager.getString("0", "ui");
			rmBtn.label			=	localeManager.getString("1", "ui");
			this["label1"].text	=	localeManager.getString("2", "ui");
			this["label2"].text	=	localeManager.getString("3", "ui");
			
			trace("Main notified.");
		}
		
		private function onLocaleOpen(e:LocaleEvent):void 
		{
			trace("XML file started loading.");
		}
		
		private function onLocaleFinish(e:LocaleEvent):void 
		{
			trace("All localized assets were notified.");
		}
		
		private function onLocaleComplete(e:LocaleEvent):void 
		{
			trace("XML file download complete");
		}
		
		private function onLocaleChange(e:LocaleEvent):void 
		{
			trace("\nLanguage changed to, "	+	e.langCode);
		}
		
		private function onLocaleError(e:LocaleEvent):void 
		{
			trace("Error! "	+	e.langCode);
		}
		
		private function removeAsset(id:String, section:String):Boolean
		{
			var child:DisplayObject;
			var comp:ILocaleComponent;
			
			for (var i:int = 0; i < this.numChildren ; i++)
			{
				child = getChildAt(i);
				
				if (child is ILocaleComponent)
				{
					comp = child as ILocaleComponent;
					if (comp.localeID == id && comp.localeSection == section)
					{
						removeChild(child);
						return true;
					}
				}
			}
			return false;
		}
		
		private function rearrangeItems():void
		{
			var child:DisplayObject;
			nextY = 100;
			
			for ( var i:int = 0; i < this.numChildren; i++)
			{
				child = getChildAt(i);
				if (child is ILocaleComponent)
				{
					child.y = 	nextY
					nextY	+=	child.height;
				}
			}
		}
	}
	
}