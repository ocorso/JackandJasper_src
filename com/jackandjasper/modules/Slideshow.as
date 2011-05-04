package com.jackandjasper.modules
{
	import com.jackandjasper.CustomEvents.CustomProgressEvent;
	import com.jackandjasper.CustomEvents.XMLLoadCompleteEvent;
	import com.jackandjasper.util.GetXML;
	import com.jackandjasper.util.IState;
	import com.jackandjasper.util.ProgressDispatcher;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	import lt.uza.utils.Global;

	public class Slideshow extends MovieClip implements IState
	{
		private var global:Global;
		private const TIMER_DELAY:int = 4000;
		private const FADE_TIME:int =	1;
		private var currentContainer:Sprite;
		private var slideshowContainer:MovieClip;
		private var slideProgressBar:ProgressBar;
		private var currentSlide:int = -1;
		private var slideCount:int;
		private var slideTimer:Timer;
		private var sprContainer1:Sprite;
		private var sprContainer2:Sprite;
		private var slideLoader:Loader;
		private var XMLPath:String = "http://www.jackandjasper.com/xml/slideshow.xml";
		private var getXML:GetXML;
		private var xmlSlideshow:XML;
		private var isFirstShow:Boolean = true;
		private var isShown:Boolean = false;
		
		public function Slideshow(ssContainer:MovieClip, progressBar:ProgressBar)
		{
			super();
			global = Global.getInstance();
			slideshowContainer = ssContainer;
			slideshowContainer.visible = false;
			slideProgressBar = progressBar;
			slideshowContainer.scaleY = 0;
			slideTimer = new Timer(TIMER_DELAY);
			sprContainer1 = new Sprite();
			sprContainer2 = new Sprite();
			slideshowContainer.addChild(sprContainer1);
			slideshowContainer.addChild(sprContainer2);	
			slideTimer.addEventListener(TimerEvent.TIMER, switchSlide);	
			sprContainer1.x = sprContainer2.x = -465;
			sprContainer1.y = sprContainer2.y = -296.5;
			currentContainer = sprContainer2;			
			//listen if we are going back and forth to home
		}//end constructor
		public function show():void{
				if(isFirstShow){
					isFirstShow = false;
					getXML = new GetXML(XMLPath);
					getXML.addEventListener(XMLLoadCompleteEvent.COMPLETE, onLoad);	
					TweenLite.to(slideshowContainer, 1, {scaleX:1, scaleY:1, ease:Circ.easeOut});
				}//end if is first time we're showing the slideshow
				slideTimer.addEventListener(TimerEvent.TIMER, switchSlide); 
				if(currentContainer==sprContainer2)	sprContainer1.alpha = 0;
				else								sprContainer2.alpha = 0;
				toggleVisibility();
				TweenLite.to(currentContainer, 1, {alpha:1, overwrite:3, onComplete: function():void{slideTimer.start();}});			
				isShown = true;
		}//end show
		public function hide():void{
			if (isShown){
					if(currentContainer==sprContainer2)	sprContainer1.alpha = 0;
					else								sprContainer2.alpha = 0;
					TweenLite.to(currentContainer, .5, {alpha:0, overwrite:3, onComplete: toggleVisibility});
					slideTimer.removeEventListener(TimerEvent.TIMER, switchSlide); 
					slideTimer.stop();
					isShown = false;
			}//end if is shown			
		}//end hide
		public function toggleVisibility():void{
			if (slideshowContainer.visible)	slideshowContainer.visible = false;
			else							slideshowContainer.visible = true;
		}//end toggleVis function
		private function onLoad(e:XMLLoadCompleteEvent):void{
			xmlSlideshow = e.xml;
			slideCount = xmlSlideshow..image.length();
			switchSlide(null);
		}
		private function switchSlide(e:TimerEvent= null):void{
			//switch slides here and keep track of who's on first, what's on second, i don't know's on third
			if(slideTimer.running)				slideTimer.stop();
			if(currentSlide+1 < slideCount)		currentSlide++;
			else								currentSlide =0;
			if(currentContainer==sprContainer2)	currentContainer=sprContainer1;
			else								currentContainer=sprContainer2;
			currentContainer.alpha = 0;
			slideshowContainer.swapChildren(sprContainer2, sprContainer1);
			
			//load slides 
			slideLoader = new Loader();
			slideLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fadeSlideIn);
			slideLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, slideLoadErrorHandler);
			slideLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, dispatchProgress);
			//only try to load a slide if you know where to load from
			if(xmlSlideshow)
				slideLoader.load(new URLRequest("http://www.jackandjasper.com/"+xmlSlideshow..image[currentSlide].@src));
		}//end of switchSlides function
		private function fadeSlideIn(e:Event):void{
			currentContainer.addChild(slideLoader.content);
			TweenLite.to(currentContainer, 1.5, {alpha:1,  onComplete:clearChildren()});
		}//end fadeSlideIn
		private function slideLoadErrorHandler(e:IOErrorEvent):void{
			trace("couldn't load the slide, maybe i should embed one here and keep loading that");
		}//loader error
		private function dispatchProgress(pe:ProgressEvent):void{
			//show the progress on the main progress bar 
			var loaded:uint = Math.round(pe.target.bytesLoaded);
			var total:uint = Math.round(pe.target.bytesTotal);
			var percent:Number = Math.floor((loaded*100)/total);
			slideProgressBar.fillBar(percent);
		}//end showProgress
		private function clearChildren():void{
			if (sprContainer1.numChildren==2)	sprContainer1.removeChildAt(0);
			if (sprContainer2.numChildren==2)	sprContainer2.removeChildAt(0);
			slideTimer.start();
		}//end clearChildren
	}//end class Slideshow
}//end package