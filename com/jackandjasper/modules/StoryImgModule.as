package com.jackandjasper.modules
{
	import com.jackandjasper.CustomEvents.XMLLoadCompleteEvent;
	import com.jackandjasper.util.Fill;
	import com.jackandjasper.util.GetXML;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import com.greensock.TweenLite;

	public class StoryImgModule extends Sprite
	{
		private var pBar:ProgressBar;
		private var imageContainer:Sprite;
		private var isSlidOut:Boolean = false;
		private var _id:Number;
		private var getXML:GetXML;
		private var xmlPath:String = "http://www.jackandjasper.com/xml/story.xml";
		private var xml:XML;
		private var loader:Loader;
		private var initialColor:Number = 0xf1ecd4;
		
		public function StoryImgModule(passedInPBar:ProgressBar)
		{
			super();
			pBar = passedInPBar;
			var f:Fill = new Fill();
			imageContainer = f.doFill(initialColor, 300,250);
			var mask:Sprite = f.doFill(0xFF0000, 300,250);
			imageContainer.mask = mask;
			addChild(mask);
			addChild(imageContainer);
			getXML = new GetXML(xmlPath);
			getXML.addEventListener(XMLLoadCompleteEvent.COMPLETE, onXMLLoad);	
		}//end constructor
		private function onXMLLoad(e:XMLLoadCompleteEvent):void{
			xml = e.xml;
		}//end onLXMLoad function
		private function loadErrorHandler(e:IOErrorEvent):void{
			trace("couldn't load the slide, maybe i should embed one here and keep loading that");
		}//loader error
		private function dispatchProgress(pe:ProgressEvent):void{
			//show the progress on the main progress bar 
			var loaded:uint = Math.round(pe.target.bytesLoaded);
			var total:uint = Math.round(pe.target.bytesTotal);
			var percent:Number = Math.floor((loaded*100)/total);
			pBar.fillBar(percent);
		}//end showProgress
		public function switchTo(id:Number=1):void{
			_id = id;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, replaceImg);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, dispatchProgress);
			loader.load(new URLRequest("http://www.jackandjasper.com/"+xml..image[id].@src));
			
		}//end slideIn
		private function replaceImg(e:Event=null):void{
			//if its already slid out, we just want to slide in the right image
			//if its currently showing something, we want to slide out then slide in.
			if (isSlidOut)	{
				imageContainer.addChild(loader.content);
				isSlidOut = false;
				slideIn();
			}// end if its slid out
			else{
				TweenLite.to(imageContainer, .75, {x:"-300", scaleX:0, scaleY:0, onComplete: replaceImg});
				isSlidOut = true;
			}//end else
		}//end replaceImg
		private function slideIn():void{
			TweenLite.to(imageContainer, .75, {x:"+300", scaleX:1, scaleY:1});
			
		}//end slideIn
		public function slideOut():void{
				TweenLite.to(imageContainer, .75, {x:"-300", scaleX:0, scaleY:0});
				isSlidOut = true;
		}//end slideOut
	}
}