package com.jackandjasper.modules
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.jackandjasper.CustomEvents.XMLLoadCompleteEvent;
	import com.jackandjasper.util.GetXML;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	public class PeopleImgModule extends MovieClip
	{
		private var pBar:ProgressBar;
		private var spr1:Sprite;
		private var spr2:Sprite;
		private var currentSpr:Sprite;
		private var XMLPath:String = "http://www.jackandjasper.com/xml/people.xml";
		private var getXML:GetXML;
		private var xml:XML;
		private var defaultImg:DefaultPeopleImg;
		private var slideLoader:Loader;
		private var id:Number;
		
		public function PeopleImgModule(mainProgBar:ProgressBar, passedInId:Number)
		{
			super();
			TweenPlugin.activate([BlurFilterPlugin]);
			pBar = mainProgBar;
			id = passedInId;
			defaultImg = new DefaultPeopleImg();
			spr1 = new Sprite();
			spr2 = new Sprite();
			defaultImg.addChild(spr1);
			defaultImg.addChild(spr2);
			currentSpr = spr2;		
			TweenMax.to(defaultImg, 0, {alpha:0, blurFilter:{blurX:40}});
			addChild(defaultImg);
			TweenMax.to(defaultImg, 1, {delay:.5, alpha:1, blurFilter:{blurX:0}});
			getXML = new GetXML(XMLPath);
			getXML.addEventListener(XMLLoadCompleteEvent.COMPLETE, onLoad);	
		}//end constructor
		
		private function onLoad(e:XMLLoadCompleteEvent):void{
			xml = e.xml;
			switchTo(id);
		}//end onLoad
		public function switchTo(id:Number):void{
			if(currentSpr==spr2)	currentSpr=spr1;
			else							currentSpr=spr2;
			TweenMax.to(currentSpr, 0, {alpha:0, blurFilter:{blurX:40}});
			defaultImg.swapChildren(spr2, spr1);
			
			//load slides 
			slideLoader = new Loader();
			slideLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fadeImgIn);
			slideLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, slideLoadErrorHandler);
			slideLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, dispatchProgress);
			//only try to load a slide if you know where to load from
			if(xml)
				slideLoader.load(new URLRequest("http://www.jackandjasper.com/"+xml..image[id].@src));
		}//end switchTo
		private function fadeImgIn(e:Event):void{
			currentSpr.addChild(slideLoader.content);
			TweenMax.to(currentSpr, 1, {alpha:1, blurFilter:{blurX:0}});
		}//end fade image in
		private function slideLoadErrorHandler(e:IOErrorEvent):void{
			trace("couldn't load the slide, maybe i should embed one here and keep loading that");
		}//loader error
		private function dispatchProgress(pe:ProgressEvent):void{
			//show the progress on the main progress bar 
			var loaded:uint = Math.round(pe.target.bytesLoaded);
			var total:uint = Math.round(pe.target.bytesTotal);
			var percent:Number = Math.floor((loaded*100)/total);
			pBar.fillBar(percent);
		}//end showProgress
	}//end class
}//end package