package com.jackandjasper.CustomEvents
{
	import flash.events.ProgressEvent;

	public class CustomProgressEvent extends ProgressEvent
	{
		public static const LOADING:String = "SomethingIsLoading";
		private var myBytesLoaded:uint;
		private var myBytesTotal:uint;
		public var percentLoaded:Number;
		
		public function CustomProgressEvent(type:String, bytesLoaded:uint=0, bytesTotal:uint=0)
		{
			super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
			this.myBytesLoaded=bytesLoaded;
			this.myBytesTotal=bytesTotal;
			percentLoaded = Math.ceil((myBytesLoaded*100)/myBytesTotal);
		}
		
	}
}