package com.jackandjasper.modules
{
	import com.jackandjasper.util.Fill;
	import com.jackandjasper.util.GetSQL;
	import com.jackandjasper.util.IState;
	import com.jackandjasper.util.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import com.greensock.TweenLite;
	
	import lt.uza.utils.Global;
	import lt.uza.utils.GlobalEvent;

	public class StoryState extends MovieClip implements IState
	{
		private var global:Global;
		private var storyContainer:StoryContainer_mc;
		private var sn:SideNav;
		private var pBar:ProgressBar;
		private var isShown:Boolean = false;
		private var sBar:ScrollBar;
		private var isFirstShow:Boolean=true;
		
		private var storyImg:StoryImgModule;
		
		public function StoryState(story_mc:StoryContainer_mc, progressBar:ProgressBar)
		{
			super();
			global = Global.getInstance();
			storyContainer=story_mc;
			storyContainer.visible = false;
			pBar = progressBar;
			var getSQL:GetSQL = new GetSQL('story');
			global.addEventListener(GlobalEvent.PROPERTY_CHANGED, globalChangeHandler);
			var f:Fill = new Fill();
			var bg:Sprite = f.doFill(global.bgColorTxt, 930,593);
			storyContainer.addChildAt(bg, 1);
			sBar = new ScrollBar(storyContainer.p);
			sBar.x = storyContainer.p.x + storyContainer.p.width;
			sBar.y = storyContainer.p.y;
			storyContainer.addChild(sBar);
			
			storyImg= new StoryImgModule(pBar);
			//distance to bottom of nav + the side nav + an additional 20
			storyImg.y = 186 + 120;
			storyImg.visible = false;
			storyContainer.addChild(storyImg);
		}//end constructor
		public function show():void{
			if(isFirstShow){
				storyImg.visible = true;
				isFirstShow = false;
			}//end if its the first time we're showing
			toggleVisibility();
			TweenLite.delayedCall(1, storyImg.switchTo, [global.id]);
			
			TweenLite.from(storyContainer.storyHdr, .5, {y: storyContainer.storyHdr.y-75, overwrite:3, alpha:1, delay:1});
			//if we have the buttons all loaded up then bring down the nave bar
			if (sn)	TweenLite.to(sn.btnContainer, .5, {y: sn.btnContainer.y+186, overwrite:3, alpha:1, delay:1.5});
			pBar.play();
			
			//TweenLite.to(storyImg, .25, {autoAlpha:1});
			isShown = true;		
		}//end show
		public function hide():void{
			if (isShown){
				TweenLite.to(sn.btnContainer, .5, {y: "-186", overwrite:3, alpha:1});
				TweenLite.to(storyContainer.storyHdr, .5, {delay: .25, y: "-75", alpha:1, overwrite:3, onComplete:toggleVisibility});
				storyImg.slideOut();
				isShown = false;
			}//end if is shown
		}//end hide
		public function toggleVisibility():void{
			if (storyContainer.visible){
					storyContainer.visible = false;
			}
			else{
				storyContainer.storyHdr.y =0;
				//if(sn)	sn.btnContainer.y -=186;
				storyContainer.visible = true;
			}
		}//end toggleVis function

		private function globalChangeHandler(e:GlobalEvent=null):void{
			if (e.property == "storySQL"){
				setText();
				makeNav();
			}//end xml loaded
			if (e.property == "id"&&global.currentState=="story"){
				setText();
				if(storyImg) storyImg.switchTo(global.id);
			}
		}//end global change handler
		private function makeNav():void{
			sn = new SideNav(global.storySQL);
			if (!global.id) global.id = 1;
			storyContainer.addChild(sn);
			if (isShown)	TweenLite.to(sn.btnContainer, .5, {y: "+186", overwrite:3, alpha:1, delay:1.5});
		}//end make side nav bar
	
		private function setText():void{
			if (global.css){
				storyContainer.h1.styleSheet = global.css;
				storyContainer.p.styleSheet = global.css;
			}//try to apply css styles	
			var i:Number= Number(global.id)-1;
			if(i<=4){
				storyContainer.h1.htmlText  = "<h1>"+ global.storySQL.section[i].h1 +"</h1>";
				if (global.id !=2) {
					storyContainer.p.htmlText	 = "<p>" + global.storySQL.section[i].p + "</p>";
				}
				else
					storyContainer.p.htmlText	 = "<h2>" + global.storySQL.section[i].p + "</h2>";
			}//end if 
			sBar.setHeight(storyContainer.p.textHeight);
		}//end setText
	}//end class
}//end package