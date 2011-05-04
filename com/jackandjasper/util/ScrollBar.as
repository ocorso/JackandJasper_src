package com.jackandjasper.util
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import lt.uza.utils.Global;

	public class ScrollBar extends Sprite
	{
		private var bar:Sprite;
		private var scroller:Sprite;
		private var global:Global;
		private var tf:TextField;
		private var barColor:Number = 0xd0ccb5;
		private var scrollerColor:Number = 0x966241;
		private var moved:Number;
		private var sBarMax:Number;
		private var percMoved:Number;
		private var percTF:Number;
		
		public function ScrollBar(target:TextField)
		{
			super();
			global = Global.getInstance();
			tf = target;
			tf.mouseWheelEnabled = true;
			sBarMax = target.height;
			var f:Fill = new Fill();
			bar = f.doFill(barColor, 15, sBarMax);
			scroller = f.doFill(scrollerColor, 10,10);
			scroller.x = scroller.y =2.5;
			bar.addChild(scroller);
			scroller.addEventListener(MouseEvent.MOUSE_DOWN, dragScroller);
			addEventListener(Event.ENTER_FRAME, updateTF);
			
			addChild(bar);
			
		}//end constructor
		
		private function dragScroller(e:MouseEvent):void{
			global.stage.addEventListener(MouseEvent.MOUSE_UP, dropScroller);			
			scroller.startDrag(false, new Rectangle(2.5, 2.5, 0, tf.height-15));
		}//end dragScroller
		private function dropScroller(e:MouseEvent):void{
			global.stage.removeEventListener(MouseEvent.MOUSE_UP, dropScroller);	
			scroller.stopDrag();
		}//end dragScroller
		private function updateTF(e:Event):void{
			moved = scroller.y - 2.5;
			percMoved = moved/sBarMax;
			tf.scrollV = percMoved*tf.maxScrollV;
		}//end updateTF
		public function setHeight(h:Number):void{
			if (h<tf.height) this.visible = false;
			else{
				this.visible = true;
			}
		}//end setHeight	
	}
}