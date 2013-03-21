package com.noomiz.screens
{
	import com.noomiz.objects.Carte;
	import com.noomiz.objects.FBUserFactory;
	import com.noomiz.objects.Partie;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.display.Scale3Image;
	import feathers.layout.VerticalLayout;
	import feathers.themes.OMDesktopTheme;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ParticleSystem;
	
	[Event(name="ticketscreen",type="starling.events.Event")]
	
	public class MainScreen extends Screen
	{
		[Embed(source="/../assets/images/skull.png")]
		private static const SKULL_ICON:Class;
		public static const TICKET_SCREEN:String = "ticketscreen";
		
		private var _ticket:ImageLoader;
		private var _header:Header;
		private var _vla:VerticalLayout;
		private var _icon:Scale3Image;

		private var labelhaut:Label;
		
		private var _dataquizz:Object;
		private var dem:Demo;
		public var partie:Partie;
		public function MainScreen()
		{
			super();
//			ExternalInterface.addCallback("flexFunction2", flexFunction2);
		}
		
		override protected function initialize():void
		{
//			var id= FlexGlobals.topLevelApplication.parameters.monid;
			if (ExternalInterface.available) {
				ExternalInterface.call("flexready", "zz");					
			//	this._header.title = "ok appel de fleex";
			} else {
				trace("ExternalInterface was not available!");
			//	this._header.title = "pb sur extranel";
			}
			// affichage direct du ticket après recup sur le serevur 
			var sc:Sprite=new Sprite();
			_ticket=new ImageLoader();
			_ticket.height=500;
			_ticket.width=500;
			_ticket.source="https://noomiz.s3.amazonaws.com/nzdata/meta/lafouine/ticket/img/ticket-surprise.png";

			addChild(sc);
			sc.addChild(_ticket);
//			_ticket.scaleX=_ticket.scaleY=0;
			_ticket.alpha=0;
			labelhaut=new Label();
			
			
			_ticket.addEventListener(TouchEvent.TOUCH, clickTicket);
								
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, xmlLoaded);		
			loader.load ( new URLRequest ("http://www9.noomiz.com/om/jsongetquizz/fbid/"+FBUserFactory.getUser().idfb) );

			//var z:MovieClip=new MovieClip();
			var undemo:Demo=new Demo();
			var zz:ParticleSystem=undemo.getexplosion();
			zz.emitterX = 320;
			zz.emitterY = 240;
			zz.start();			
			addChild(zz);
			Starling.juggler.add(zz);
			
//			
			
		}
		private function clickTicket(evt:TouchEvent):void
		{
			//trace("clickticket");
			//evt.stopImmediatePropagation();
			var ztick:ImageLoader=evt.currentTarget as ImageLoader;
			//trace(evt.getTouch(ztick,"ended"));
						
			//var mc:Carte=evt.currentTarget as Carte;			
			if(evt.getTouch(this,TouchPhase.ENDED)){
				trace("clickticket ok");
				dem=new Demo();
				addChild(dem);
//				dem.visible=false;

				//		_ticket.visible=false;
//				dem.visible=true;
				//				this._snd.play();
//				dem.visible=true;
				
//				dem.visible=false;	
				//			
				
				
				
//				addChild(dem);
			}
		}
		
		// questions loaded
		public function xmlLoaded(event:flash.events.Event):void {
			var loader:URLLoader = URLLoader(event.target);
			this._dataquizz=JSON.parse(loader.data);
			partie.dataquizz=this._dataquizz;
			if(this._dataquizz.ok==1){
				var tween1:Tween=new Tween(_ticket,2,"easeOutElastic");
				//tween1.animate("x",200);
				tween1.animate("alpha",1);
				tween1.scaleTo(1);
				tween1.delay=1;
				Starling.juggler.add(tween1);				
			}
			//Starling.juggler.add(tween2);
/*
			
			dataXML = selectQuestions(tempXML,10);
			gameSprite.removeChild(messageField);
			messageField = createText("Get ready for the first question!",questionFormat,gameSprite,0,60,550);
			showGameButton("GO!");
*/		}

		
		override protected function draw():void
		{
//			this._header.width = this.actualWidth;
			this._ticket.validate();
			
		}
		
		private function btnjouerButton_triggeredHandler(event:starling.events.Event):void
		{
			// passer les données
			this.dispatchEventWith(TICKET_SCREEN);
		}		
	}
}