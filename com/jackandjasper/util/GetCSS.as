package com.jackandjasper.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	
	import lt.uza.utils.Global;
	
	public class GetCSS
	{
		private var global:Global;
		private var cssLoader:URLLoader;
		public function GetCSS()
		{
			global = Global.getInstance();
			cssLoader = new URLLoader();
			var cssRequest:URLRequest = new URLRequest("../css/mainFlash.css");
			cssLoader.addEventListener(Event.COMPLETE, cssLoaderCompleteHandler);
			cssLoader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			cssLoader.load(cssRequest);
			
		}//end constructor
		private function IOErrorHandler(e:IOErrorEvent):void{
			trace("i couldn't load the css data from internet, trying locally");
			cssLoader = new URLLoader();
			var cssRequest:URLRequest = new URLRequest("css/mainFlash.css");
			cssLoader.load(cssRequest);

		}
		private function cssLoaderCompleteHandler(e:Event):void{
				var css:StyleSheet = new StyleSheet();
				css.parseCSS(e.target.data);
				global.css = css;
				
		}//end complete 
	}
}