package com.jackandjasper.util
{
	import com.jackandjasper.Site;
	import com.jackandjasper.modules.Footer;
	
	import flash.display.Sprite;

	public class Background extends Sprite
	{
		private var fillSprite:Sprite;
		private var _color:Number;
		public function Background(color:Number, w:Number, h:Number)
		{
			super();
			_color = color;
			fillSprite = new Sprite();
			fillSprite.visible= false;
			makeFullBG(w, h);
			addChild(fillSprite);
		}
		public function makeFullBG(w:Number, h:Number, s:Site=null, f:Footer=null):void{
			fillSprite.graphics.clear();
			fillSprite.graphics.beginFill(_color, 1);
			fillSprite.graphics.drawRect(0,0,w,h);
			fillSprite.graphics.endFill();
			
			var stageCenterX:Number = fillSprite.width/2;
			//s and f are null the very first time the background is drawn, after that they're not
			//footer is positioned correctly justified under the site
			if(s){
				f.y = s.height-100;
				var siteCenterX:Number = s.width/2;
				if(stageCenterX>siteCenterX) {
					s.x = stageCenterX;
					f.x = stageCenterX-465;					
				}//end if	
				else {
					s.x = siteCenterX;	
					f.x = siteCenterX-465;					
				}
				s.y = s.height/2;
				f.visible = true;
			}
			
		}//end function
		
	}
}