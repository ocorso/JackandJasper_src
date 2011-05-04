package com.jackandjasper.modules
{
	import com.greensock.TweenLite;
	import com.jackandjasper.util.Fill;
	import com.jackandjasper.util.GetSQL;
	import com.jackandjasper.util.IState;
	import com.jackandjasper.util.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import lt.uza.utils.Global;
	import lt.uza.utils.GlobalEvent;

	public class VineyardsState extends MovieClip implements IState
	{
		private var global:Global;
		private var vineyardsContainer:VineyardsContainer_mc;
		private var sn:SideNav;
		private var pBar:ProgressBar;
		private var isShown:Boolean = false;
		private var sBar:ScrollBar;
		private var isFirstShow:Boolean=true;
		
		private var vineyardsImg:VineyardsImgModule;
		
		public function VineyardsState(vineyards_mc:VineyardsContainer_mc, progressBar:ProgressBar)
		{
			super();
			global = Global.getInstance();
			vineyardsContainer=vineyards_mc;
			vineyardsContainer.visible = false;
			pBar = progressBar;
			var getSQL:GetSQL = new GetSQL('vineyards');
			global.addEventListener(GlobalEvent.PROPERTY_CHANGED, globalChangeHandler);
			var f:Fill = new Fill();
			var bg:Sprite = f.doFill(global.bgColorTxt, 930,593);
			vineyardsContainer.addChildAt(bg, 1);
			sBar = new ScrollBar(vineyardsContainer.p);
			sBar.x = vineyardsContainer.p.x + vineyardsContainer.p.width;
			sBar.y = vineyardsContainer.p.y;
			vineyardsContainer.addChild(sBar);
			 
			vineyardsImg= new VineyardsImgModule(pBar);
			//distance to bottom of nav + the side nav + an additional 20
			vineyardsImg.x = 320;
			vineyardsImg.y = 280;
			vineyardsContainer.addChild(vineyardsImg); 
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}//end constructor
		public function show():void{
			if(isFirstShow){
				isFirstShow = false;
			}//end if its the first time we're showing
			toggleVisibility();
			TweenLite.delayedCall(1, vineyardsImg.switchTo, [global.id]);
			TweenLite.from(vineyardsContainer.vineyardsHdr, .5, {y: vineyardsContainer.vineyardsHdr.y-75, overwrite:3, alpha:1, delay:1});
			//if we have the buttons all loaded up then bring down the nave bar
			if (sn)	TweenLite.to(sn.btnContainer, .5, {y: sn.btnContainer.y+186, overwrite:3, alpha:1, delay:1.5});
			pBar.play();
			isShown = true;		
		}//end show
		public function hide():void{
			if (isShown){
				TweenLite.to(sn.btnContainer, .5, {y: "-186", overwrite:3, alpha:1});
				TweenLite.to(vineyardsContainer.vineyardsHdr, .5, {delay: .25, y: "-75", alpha:1, overwrite:3, onComplete:toggleVisibility});
				vineyardsImg.slideOut();
				isShown = false;
			}//end if is shown
		}//end hide
		public function toggleVisibility():void{
			if (vineyardsContainer.visible){
					vineyardsContainer.visible = false;
			}
			else{
				vineyardsContainer.vineyardsHdr.y =0;
				vineyardsContainer.visible = true;
			}
		}//end toggleVis function

		private function globalChangeHandler(e:GlobalEvent=null):void{
			if (e.property == "vineyardsSQL"){
				setText();
				makeNav();
			}//end xml loaded
			if (e.property == "id"&&global.currentState=="vineyards"){
				setText();
				if(vineyardsImg) vineyardsImg.switchTo(global.id);
			}
		}//end global change handler
		private function makeNav():void{
			sn = new SideNav(global.vineyardsSQL);
			if (!global.id) global.id = 1;
			vineyardsContainer.addChild(sn);
			if (isShown)	TweenLite.to(sn.btnContainer, .5, {y: "+186", overwrite:3, alpha:1, delay:1.5});
		}//end make side nav bar
	
		private function setText():void{
			if (global.css){
				vineyardsContainer.h1.styleSheet = global.css;
				vineyardsContainer.p.styleSheet = global.css;
			}//try to apply css styles	
			var i:Number= Number(global.id)-1;
			if(i<=4){
				vineyardsContainer.h1.htmlText  = "<h1>"+ global.vineyardsSQL.section[i].h1 +"</h1>";
				vineyardsContainer.h2.htmlText	 = "<h2>" + global.vineyardsSQL.section[i].h2 + "</h2>";
				vineyardsContainer.p.htmlText	 = "<p>" + global.vineyardsSQL.section[i].p + "</p>";
			}//end if 
			sBar.setHeight(vineyardsContainer.p.textHeight);
		}//end setText
		private function onEnterFrameHandler(e:Event):void{
			vineyardsContainer.p.x = vineyardsImg.width + vineyardsImg.x + 20;
		}//enter frame function
	}//end class
}//end package