package com.jackandjasper
{
	import com.jackandjasper.modules.PeopleState;
	import com.jackandjasper.modules.ProgressBar;
	import com.jackandjasper.modules.Slideshow;
	import com.jackandjasper.modules.StoryState;
	import com.jackandjasper.modules.VineyardsState;
	
	import flash.display.MovieClip;
	
	import com.greensock.TweenLite;
	
	import lt.uza.utils.Global;
	import lt.uza.utils.GlobalEvent;

	public class Site extends MovieClip
	{	
		private var global:Global;
		private var mainProgressBar:ProgressBar;
		private var slideshow:Slideshow;
		private var people:PeopleState;
		private var story:StoryState;
		private var vineyards:VineyardsState;
				
		public function Site(state:String)
		{
			super();
			global = Global.getInstance();		
			//initialize site and fade it on the stage
			var site:Site_mc = new Site_mc();
			site.alpha = 0;
			site.brightness = -1;
			mainProgressBar = site.progressBarInstance;
			this.addChild(site);
			TweenLite.to(site, 1.5, {alpha:1, brightness:0});
			
			//initialize states
			slideshow = new Slideshow (site.mainContainerInstance, mainProgressBar);
			people = new PeopleState(site.peopleContainerInstance, mainProgressBar);
			story = new StoryState(site.storyContainerInstance, mainProgressBar);
			vineyards = new VineyardsState(site.VineyardsContainerInstance, mainProgressBar);
			
			//show first state and listen for state changes			
			if(global.currentState)		manageStates();
			global.addEventListener(GlobalEvent.PROPERTY_CHANGED, manageStates);

			}//end Site constructor
			//this function has a switch that causes the site to display the inital state and section that's passed in via flashvars
			//also its the global listener handler for state changes
			private function manageStates(e:GlobalEvent=null):void{
				if(!e||e.property=="currentState"){
					switch (global.currentState){
						case "home" : TweenLite.delayedCall(.75, slideshow.show);
							if (e)	global.id =1;
							hideOthers();
							break;
						case "people" : TweenLite.delayedCall(.75, people.show);
							if (e)	global.id =1;
							hideOthers();
							break;
						case "story" : TweenLite.delayedCall(.75, story.show);
							if (e)	global.id =1;
							hideOthers();
							break;
						case "vineyards" : TweenLite.delayedCall(.75, vineyards.show);
							if (e)	global.id =1;
							hideOthers();
							break;
						default : trace("we haven't made this yet");
							slideshow.hide();
							people.hide();
					}//end switch
				}//end if
			}//end of showInitialState function
			private function hideOthers():void{
				if(global.currentState!= "home")	slideshow.hide();
				if(global.currentState!= "people")	people.hide();
				if(global.currentState!= "story")	story.hide();
				if(global.currentState!= "vineyards")	vineyards.hide();
				
			}//end hideOthers
	}//end class Site
}//end package