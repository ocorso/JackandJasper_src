package com.jackandjasper.util
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.plugins.RemoveTintPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import lt.uza.utils.Global;

	public class SideNavBtn extends Sprite
	{
		private var global:Global;
		private var id:Number;
		private var spr:Sprite;
		private var tf:TextField;
		private const outColor:Number = 0xd0ccb5;
		private const overColor:Number = 0xFFFF66;
		private const textTint:Number = 0x966241;
		private var myOverTintTween:TweenLite;
		
		
		public function SideNavBtn(passedInID:Number, passedInLabel:String)
		{
			super();
			global = Global.getInstance();
			TweenPlugin.activate([TintPlugin, RemoveTintPlugin]);
			id = passedInID;
			var f:Fill = new Fill();
			spr = f.doFill(outColor, 300, 40);
			tf = new TextField();
			tf.x = tf. y = 10;
			tf.selectable = false;
			if(global.css){
				tf.styleSheet = global.css;
			}
			tf.htmlText = "<p>" + passedInLabel + "</p>";
			addChild(spr);
			addChild(tf);
			addEventListener(MouseEvent.ROLL_OVER, over);
			addEventListener(MouseEvent.ROLL_OUT, out);
			addEventListener(MouseEvent.CLICK, clicked);
			
		}
		private function over(e:MouseEvent=null):void{
			myOverTintTween = TweenLite.to(spr, 1, {tint:overColor, ease:Back.easeOut});
			TweenLite.to(tf, 1, {tint:textTint, scaleX:1.2, scaleY:1.2, x:20, ease:Back.easeOut});
			
		}//end over
		private function out(e:MouseEvent):void{
			myOverTintTween = TweenLite.to(spr, 1, {removeTint:true, ease:Back.easeOut});
			TweenLite.to(tf, 1, {removeTint:true, scaleX:1, scaleY:1, x:10, ease:Back.easeOut});
		}//end out
		private function clicked(e:MouseEvent):void{
			global.id = id;
			
		}//end clicked

	}//end class SideNavBtn
}//end package