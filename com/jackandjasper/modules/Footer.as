package com.jackandjasper.modules
{
	import com.jackandjasper.util.Fill;
	
	import flash.display.Sprite;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	import lt.uza.utils.Global;
	import lt.uza.utils.GlobalEvent;

	public class Footer extends Sprite
	{
		private var global:Global;
		private var footerTxt:TextField;
		private var pageContent:String;
		public function Footer()
		{
			super();
			pageContent = "<h3>Jack & Jasper Cellars, LLC, All Rights Reserved ©2010  •  75 Hampshire Hill Road   •   Upper Saddle River, NJ 07458   •   917-589-8623</h3>";	
			pageContent +="<h3><a href='/pages/policies.php'>our policies</a>  |  <a href='/pages/credits.php'>credits</a>  |  <a href='/pages/sitemap.php'>sitemap</a>  |  <a href='/php/admin/jackandjasperCMS.html'>login</a></h3>";
			global = Global.getInstance();
			
			footerTxt = new TextField();
			footerTxt.multiline = true;
			footerTxt.wordWrap = true;
			footerTxt.width = 900;
			if(!global.css) 	global.addEventListener(GlobalEvent.PROPERTY_CHANGED, attachCSS);
			else				attachCSS();
		}//end constructor
		private function attachCSS(e:GlobalEvent=null):void{
			if(e.property == "css"){				
				removeEventListener(GlobalEvent.PROPERTY_CHANGED, attachCSS);
				footerTxt.styleSheet = global.css;
				
				footerTxt.htmlText = pageContent;
				addChild(footerTxt);				
			}
			else if (global.css == null) 	trace("couldn't load css in time");				
		}	
	}//end class footer
}//end package