package com.jackandjasper.util
{
	import com.jackandjasper.CustomEvents.XMLLoadCompleteEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class GetXML extends EventDispatcher
	{
		private var xml:XML;
		
		public function GetXML(xmlPath:String)
		{
			super();
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, onXMLLoadComplete);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadError);
			xmlLoader.load(new URLRequest(xmlPath));
		
		}//end constructor
		public function onXMLLoadComplete(e:Event):void{
			trace(" xml load complete");
			xml = new XML(e.target.data);
			this.dispatchEvent(new XMLLoadCompleteEvent(XMLLoadCompleteEvent.COMPLETE, xml));			
		}//end onLoad

		private function onXMLLoadError(e:IOErrorEvent):void{
			trace("xml load error");
		}//end error handler
		
	}//end GetXML class
}//end package