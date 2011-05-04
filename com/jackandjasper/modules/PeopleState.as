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

	public class PeopleState extends MovieClip implements IState
	{
		private var global:Global;
		private var peopleContainer:PeopleContainer_mc;
		private var sn:SideNav;
		private var pBar:ProgressBar;
		private var isShown:Boolean = false;
		private var peopleImgModule:PeopleImgModule;
		private var sBar:ScrollBar;
		
		public function PeopleState(people_mc:PeopleContainer_mc, progressBar:ProgressBar)
		{
			super();
			global = Global.getInstance();
			peopleContainer=people_mc;
			peopleContainer.visible = false;
			pBar = progressBar;
			var getSQL:GetSQL = new GetSQL('people');
			global.addEventListener(GlobalEvent.PROPERTY_CHANGED, globalChangeHandler);
			var f:Fill = new Fill();
			var bg:Sprite = f.doFill(global.bgColorTxt, 930,593);
			peopleContainer.addChildAt(bg, 1);
			sBar = new ScrollBar(peopleContainer.p);
			sBar.x = peopleContainer.p.x + peopleContainer.p.width;
			sBar.y = peopleContainer.p.y;
			peopleContainer.addChild(sBar);
			sBar.visible = false;
		}//end constructor
		public function show():void{
			toggleVisibility();
			if(!peopleImgModule)	makeImg();
			else	peopleImgModule.switchTo(global.id);
			trace(peopleContainer.peopleHdr.y);
			TweenLite.from(peopleContainer.peopleHdr, .5, {y: peopleContainer.peopleHdr.y-75, overwrite:3, alpha:1, delay:1});
			//if we have the buttons all loaded up then bring down the nave bar
			if (sn)	TweenLite.to(sn.btnContainer, .5, {y: sn.btnContainer.y+186, overwrite:3, alpha:1, delay:1.5});
			pBar.play();
			
			TweenLite.to(peopleImgModule, .25, {autoAlpha:1});
			isShown = true;		
		}//end show
		public function hide():void{
			if (isShown){
				TweenLite.to(sn.btnContainer, .5, {y: "-186", overwrite:3, alpha:1});
				TweenLite.to(peopleContainer.peopleHdr, .5, {delay: .25, y: "-75", alpha:1, overwrite:3, onComplete:toggleVisibility});
				TweenLite.to(peopleImgModule, .25, {autoAlpha:0});
				isShown = false;
			}//end if is shown
		}//end hide
		public function toggleVisibility():void{
			if (peopleContainer.visible){
					peopleContainer.visible = false;
					trace(peopleContainer.peopleHdr.y);				
			}
			else{
				peopleContainer.peopleHdr.y =0;
				//if(sn)	sn.btnContainer.y -=186;
				peopleContainer.visible = true;
			}
		}//end toggleVis function

		private function globalChangeHandler(e:GlobalEvent=null):void{
			if (e.property == "peopleSQL"){
				setText();
				makeNav();
			}//end xml loaded
			if (e.property == "id"){
				setText();
				if(peopleImgModule) peopleImgModule.switchTo(global.id);
			}
		}//end global change handler
		private function makeNav():void{
			sn = new SideNav(global.peopleSQL);
			peopleContainer.addChild(sn);
			if (isShown)	TweenLite.to(sn.btnContainer, .5, {y: "+186", overwrite:3, alpha:1, delay:1.5});
		}//end make side nav bar
		private function makeImg():void{
			peopleImgModule = new PeopleImgModule(pBar, global.id); 
			peopleImgModule.x = 740;
			peopleImgModule.y = 250;
			peopleContainer.addChild(peopleImgModule);
		}//end make image
		private function setText():void{
			if (global.css){
				peopleContainer.h1.styleSheet = global.css;
				peopleContainer.p.styleSheet = global.css;
			}//try to apply css styles	
			var i:Number= Number(global.id)-1;
			if(i<=4){
				peopleContainer.h1.htmlText  = "<h1>"+ global.peopleSQL.section[i].h1 +"</h1>";
				peopleContainer.p.htmlText	 = "<p>" + global.peopleSQL.section[i].p + "</p>";
			}//end if 
			sBar.setHeight(peopleContainer.p.textHeight);
		}//end setText
	}//end class
}//end package