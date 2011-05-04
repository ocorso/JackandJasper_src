package {
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.utils.Out;
	import com.jackandjasper.Site;
	import com.jackandjasper.modules.Footer;
	import com.jackandjasper.util.Background;
	import com.jackandjasper.util.GetCSS;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import lt.uza.utils.Global;
	import lt.uza.utils.GlobalEvent;
	
	import net.ored.util.ORedUtils;

	/**
	 * 
	 * @author owen corso
	 * 
	 * here are the global variables 
	 * bgColor:Number	= color of main background
	 * css:StyleSheet	= main.css
	 * state:String		= name of the current state
	 * id				= number of the current section of the state
	 *
	 * peopleXML		= xml file telling us where to get the pictures	
	 * storyXML			= xml file telling us where to get the pictures	
	 * vineyardsXML		= xml file telling us where to get the pictures	
	 * 
	 * peopleSQL		= text content for this section we retrieved from the database
	 * storySQL			= text content for this section we retrieved from the database
	 * vineyardsSQL		= text content for this section we retrieved from the database
	 * 
	 */	
	[SWF (width="1000", height="643", backgroundColor="#ffffff", frameRate="30")]
	public class jackandjasper extends MovieClip
	{
		private var global:Global;
		private var site:Site;
		private var footer:Footer;
		private var bg:Background;
		private var state:String;
		private var id:Number = 0;
		private const CRUSHPAD:String = "http://jackandjaspercellars.securewinemerchant.com";
		
		public function jackandjasper()
		{
			ORedUtils.turnOutOn();
			Out.info(this, "Welcome!");
			Out.debug(this, Environment.DOMAIN);
			//tell me on the state what flashvars has in it... all i care about is currentState and the section of that state  
			var allFlashVars:Object = LoaderInfo(this.root.loaderInfo).parameters;
			if (allFlashVars['state']){
				state = allFlashVars.state;
				id = allFlashVars.id;
				trace("The currentState is now: "+ state);
				trace("The id is now: "+ id);
			}//end if we got the currentState in as a Flashvars attribute
			global = Global.getInstance();
			_setGlobals();
			
			//setup stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			bg = new Background(global.bgColor, stage.stageWidth, stage.stageHeight);
			site = new Site(state);
			addChild(bg);
			addChild(site);
			//add footer to bottom of the site
			footer = new Footer();
			footer.visible = false;
			addChild(footer);	
		
			stage.addEventListener(Event.RESIZE, resizeHandler);
			stage.dispatchEvent(new Event(Event.RESIZE));
			
		}//end constructor
		private function resizeHandler(e:Event):void{
			bg.makeFullBG(stage.stageWidth, stage.stageHeight, site, footer);			
		}//end resize
		private function _setGlobals():void{
			global.domain		= (Environment.DOMAIN == "localhost" || Environment.DOMAIN == "jackandjasper.local") ? "http://jackandjasper.local" : "http://www.jackandjasper.com";
			global.currentState = state;
			global.id 			= id;
			global.stage 		= this.stage;
			global.bgColor 		= 0xa19f90;
			global.bgColorTxt 	= 0xf1ecd4;
			var getCSS:GetCSS 	= new GetCSS();
			global.crushpadURL 	= CRUSHPAD;
			global.addEventListener(GlobalEvent.PROPERTY_CHANGED, globalSetHandler);		
		}//end setGlobals
		
		private function globalSetHandler(e:GlobalEvent):void{
			Out.status(this, "property "+ e.property + " has changed to " + global[e.property]);
		}//end global set handler
	}//end class
	
}
