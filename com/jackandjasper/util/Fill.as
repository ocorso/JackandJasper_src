package com.jackandjasper.util
{
	import flash.display.Sprite;

	public class Fill extends Sprite
	{
		public function Fill()
		{
			super();
		}
		public function doFill(color:Number, w:Number, h:Number):Sprite{
			var fillSprite:Sprite = new Sprite();
			fillSprite.graphics.beginFill(color, 1);
			fillSprite.graphics.drawRect(0,0,w,h);
			fillSprite.graphics.endFill();
			return fillSprite;
		}//end doFill
	}//end class
}//end package