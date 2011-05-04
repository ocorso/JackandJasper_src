package com.jackandjasper.modules
{
	import flash.display.MovieClip;

	public class ProgressBar extends MovieClip
	{
		public function ProgressBar()
		{
			super();
			this.stop();
				
		}//end constructor
		public function fillBar(percent:Number):void{
			gotoAndStop(percent);
		}//end fillBar function
	}//end class
}//end package