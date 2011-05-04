package com.jackandjasper.CustomEvents
{
	import flash.events.Event;

	public class XMLLoadCompleteEvent extends Event
	{
		public static const COMPLETE:String = "XMLFinishedLoading";
		public var xml:XML;
		
		public function XMLLoadCompleteEvent(type:String, xml:XML)
		{
			this.xml = xml;
			super(type);
		}//end constructor
		
	}//end custom event class
}//end package