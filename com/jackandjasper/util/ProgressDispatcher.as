package com.jackandjasper.util
{
	import com.jackandjasper.CustomEvents.CustomProgressEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class ProgressDispatcher extends EventDispatcher
	{
		public function ProgressDispatcher(target:IEventDispatcher=null)
		{
			super(target);			
		}
	}
}