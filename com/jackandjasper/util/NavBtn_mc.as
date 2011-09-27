package com.jackandjasper.util
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import lt.uza.utils.Global;

	public class NavBtn_mc extends MovieClip 
	{
		private var global:Global;
		
		public function NavBtn_mc()
		{
			global = Global.getInstance();
			super();
			this.alpha = 0;
			addEventListener(MouseEvent.ROLL_OVER, over);
			addEventListener(MouseEvent.ROLL_OUT, out);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		private function over(e:MouseEvent):void{
			TweenLite.to(this, .75, {alpha:1});
		}
		
		private function out(e:MouseEvent):void{
			TweenLite.to(this, .75, {alpha:0});
		}
		
		private function clickHandler(e:MouseEvent):void{
			
			switch(e.target.toString()) {
				case "[object Home_mc]": global.currentState = "home";
					break;				
				case "[object People_mc]": global.currentState = "people";
					break;				
				case "[object Wineclub_mc]": global.currentState = "jacksclub";
					navToURL();
					break;				
				case "[object Acquire_mc]": global.currentState = "acquire";
					navToURL(true);					
					break;				
				case "[object Contact_mc]": global.currentState = "contact";
					navToURL();					
					break;				
				case "[object Story_mc]": global.currentState = "story";
					break;				
				case "[object Vineyards_mc]": global.currentState = "vineyards";
					break;
				case "[object Wines_mc]": global.currentState = "wines";
					navToURL(true);					
					break;
				default : trace(e.target);
				
			}//end switch
		}//end click handler
		
		private function navToURL($isShop:Boolean = false):void{
			
			var path:String = $isShop ? "../pages/shop.php" : "../pages/"+ global.currentState+".php";
			var request:URLRequest = new URLRequest(path);
			flash.net.navigateToURL(request, "_self");
		
		}//end function
		
	}//end NavBtn_mc class
}//end package