package com.jackandjasper.modules
{
	import com.jackandjasper.util.Fill;
	import com.jackandjasper.util.SideNavBtn;
	
	import flash.display.Sprite;
	
	import com.greensock.TweenLite;
	
	import lt.uza.utils.Global;
	
	public class SideNav extends Sprite
	{
		public var btnContainer:Sprite;
		private var global:Global;
		private var stateXML:XMLList; 
		
		public function SideNav(xml:XML)
		{
			super();
			global = Global.getInstance();
			stateXML = new XMLList(xml.section);
			btnContainer = new Sprite();
			addChild(btnContainer);
			
			var f:Fill = new Fill();
			var maskingSpr:Sprite = f.doFill(0x00FFFF, 310, (stateXML.length()*40));
			maskingSpr.y=186;
			addChild(maskingSpr);
			btnContainer.mask = maskingSpr;
			for (var i:int=0; i<stateXML.length(); i++){
				var btn:SideNavBtn = new SideNavBtn(stateXML[i].id, stateXML[i].h1);
				btn.y = 40*i;
				btnContainer.addChild(btn);
			}//end for

		}//end constructor

	}
}