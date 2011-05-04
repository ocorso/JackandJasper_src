package com.jackandjasper.util
{
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.utils.Out;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import lt.uza.utils.Global;
	
	public class GetSQL
	{
		private var _state:String;
		
		private var global:Global;
		public function GetSQL(state:String)
		{
			Out.status(this, "GetSQL");
			global = Global.getInstance();
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, dataLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			var variables:URLVariables = new URLVariables();
			var request:URLRequest =  new URLRequest(global.domain+'/php/sql-to-xml.php');
			variables.state = state;
			request.method = 'POST';
			request.data = variables;
			Out.debug(this, request.url);
			loader.load(request);
			_state = state;
			
		}//end constructor
		private function dataLoaded(e:Event):void{
			var xmlResponse:XML = XML ((e.target as URLLoader).data);
			switch (_state){
				case "people" : global.peopleSQL = xmlResponse;
					break;
				case "news" : global.newsSQL = xmlResponse;
					break;
				case "story" : global.storySQL = xmlResponse;
					break;
				case "vineyards" : global.vineyardsSQL = xmlResponse;
					break;
				case "wines" : global.winesSQL = xmlResponse;
					break;
				default : trace("i have no idea what your doing");
			}//end switch
		}//end dataLoaded
		private function IOErrorHandler(e:IOErrorEvent):void{
			trace("i couldn't load the database info");
		}//end io error handler
	}
}