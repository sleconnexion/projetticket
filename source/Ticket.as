package
{
	import com.noomiz.objects.FBUserFactory;
	import com.noomiz.objects.Partie;
	import com.noomiz.sounds.MemoryHome;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.OMDesktopTheme;
	
	import org.osmf.layout.HorizontalAlign;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Ticket extends Sprite
	{
		public var partie:Partie;
		private var _q1:starling.display.Image;
		private var _q2:starling.display.Image;
		private var _q3:starling.display.Image;
		private var _qtxt1:Label;
		private var _qtxt2:Label;
		private var _qtxt3:Label;

		private var _labelpts:Label;
		private var _pts:uint;
		private var _score:uint;
		private var _nbok:uint;
		
		
		private var _currentquestion:Label;
		private var _btn1:Button;
		private var _btn2:Button;
		private var _btn3:Button;
		private var _btn4:Button;
		
		private var _xcurrentquestion:Number;
		private var _xbtn1:Number;
		private var _xbtn2:Number;
		private var _xbtn3:Number;
		private var _xbtn4:Number;
		
		private var _currentindexquestion;
		
		private var _maclock:Timer = new Timer(1000,0);
		private var _maclocknettoyeur:Timer = new Timer(1000,1);

		private var _tickserveur:Number=0;
		private var _clockretardserveur:Timer = new Timer(1000,0);
		private var _responseserveur:uint=2;
		private var _nbptsfb:uint=0;
		private var _scanim:ScrollContainer;
		private var _zztaff:uint;
		public function Ticket()
		{
			trace("Game constructor");

		}
		public function startgame():void{
			// afficahge de la première question
			_pts=100;
			_score=0;
			_nbok=0;
			_responseserveur=2;
			var _sc:ScrollContainer=new ScrollContainer();
			_sc.width=500;
			
			this._clockretardserveur.addEventListener(TimerEvent.TIMER, fntickerserveur);

			
			var vlay:VerticalLayout=new VerticalLayout();
			vlay.horizontalAlign=HorizontalAlign.CENTER
			vlay.gap=20;
			_sc.layout=vlay;			
			addChild(_sc);
			
			// premiere ligne en horieontale
			var scligne1:ScrollContainer=new ScrollContainer();
			var scligne1lay:HorizontalLayout=new HorizontalLayout();
			scligne1lay.horizontalAlign=HorizontalAlign.CENTER;
			scligne1lay.gap=20;
			scligne1.layout=scligne1lay;			
			_sc.addChild(scligne1);
			
			// en hdr les 3 questions
			var sp1:Sprite=new Sprite();
			var sp2:Sprite=new Sprite();
			var sp3:Sprite=new Sprite();
			var matexture2:Texture=PowerUpFactory.getTxt(PowerUpFactory.IMGSTAR32);

			_q1=new Image(matexture2);			
			_q1.width=100;
			_qtxt1=new Label();
			scligne1.addChild(sp1);
			sp1.addChild(_q1);
			sp1.addChild(_qtxt1);
			_q2=new Image(matexture2);
			_q2.width=100;
			_qtxt2=new Label();
			scligne1.addChild(sp2);
			sp2.addChild(_q2);
			sp2.addChild(_qtxt2);
			_q3=new Image(matexture2);
			_qtxt3=new Label();
			_q3.width=100;
			scligne1.addChild(sp3);
			sp3.addChild(_q3);
			sp3.addChild(_qtxt3);
			
			
			// ligne 2 les points
			_labelpts=new Label();
			_labelpts.nameList.add(OMDesktopTheme.ALTERNATE_NAME_OM_CUSTOM_QUIZZPTS);
			_labelpts.width=400;
			_labelpts.text=""+_pts+" pts";
			_sc.addChild(_labelpts);
			
			// ligne 3 current question
			_currentindexquestion=0;
			_currentquestion=new Label();
			_currentquestion.nameList.add(OMDesktopTheme.ALTERNATE_NAME_OM_CUSTOM_QUIZZQUESTION);
			_currentquestion.width=400;
			_currentquestion.text=partie.dataquizz.questions[_currentindexquestion].TITREQUESTION;
//			_currentquestion.textRendererProperties.wordWrap = true;
			_sc.addChild(_currentquestion);
	
			// ligne 4 deux rep
			var scligne41:ScrollContainer=new ScrollContainer();
			var scligne41lay:HorizontalLayout=new HorizontalLayout();
			scligne41lay.horizontalAlign=HorizontalAlign.CENTER;
			scligne41lay.gap=20;
			scligne41.layout=scligne41lay;			
			_sc.addChild(scligne41);
			_btn1=new Button();
			_btn1.name="1";
			_btn1.label=partie.dataquizz.questions[_currentindexquestion].REPONSE1;
			_btn2=new Button();
			_btn2.name="2";
			_btn2.label=partie.dataquizz.questions[_currentindexquestion].REPONSE2;
			scligne41.addChild(_btn1);
			scligne41.addChild(_btn2);
			
			// ligne 4 deux rep bas
			var scligne42:ScrollContainer=new ScrollContainer();
			var scligne42lay:HorizontalLayout=new HorizontalLayout();
			scligne42lay.horizontalAlign=HorizontalAlign.CENTER;
			scligne42lay.gap=20;
			scligne42.layout=scligne42lay;
			_sc.addChild(scligne42);
			_btn3=new Button();
			_btn3.name="3";
			_btn3.label=partie.dataquizz.questions[_currentindexquestion].REPONSE3;
			_btn4=new Button();
			_btn4.name="4";
			_btn4.label=partie.dataquizz.questions[_currentindexquestion].REPONSE3;
			scligne42.addChild(_btn3);
			scligne42.addChild(_btn4);
			
			_btn1.width=_btn2.width=_btn3.width=_btn4.width=120;
			_btn1.height=_btn2.height=_btn3.height=_btn4.height=60;
			
			_btn1.addEventListener(starling.events.Event.TRIGGERED, btn_triggeredHandler);				
			_btn2.addEventListener(starling.events.Event.TRIGGERED, btn_triggeredHandler);				
			_btn3.addEventListener(starling.events.Event.TRIGGERED, btn_triggeredHandler);				
			_btn4.addEventListener(starling.events.Event.TRIGGERED, btn_triggeredHandler);				
				// lct timer
			this._maclock.addEventListener(TimerEvent.TIMER, fnticker);
			_maclock.start();
			
			_scanim=new ScrollContainer();
			this._maclocknettoyeur.addEventListener(TimerEvent.TIMER, fntickernettoyeur);

		}
		private function fnticker(evt:TimerEvent):void{
			if(this._pts<=10){
				_maclock.stop();
				this._pts=10;
			} else {
				this._pts-=5;
			}
			_labelpts.text=""+this._pts+" pts";
		}
		private function btn_triggeredHandler(event:starling.events.Event):void
		{
			var target:Button=event.currentTarget as Button;
			_maclock.stop();
			if(partie.dataquizz.questions[_currentindexquestion].REPONSEGAGNANTE==target.name){
				var zz1:Point=new Point(target.width/2,target.height/2);
				var ptglobal1:Point=target.localToGlobal(zz1);
				target.label="OK:"+target.name;
				// on met à jour les points
				_score+=_pts;
				_nbok++;
				switch(_currentindexquestion){
					case 0:
						_q1.texture=PowerUpFactory.getTxt(PowerUpFactory.IMG1);
						_qtxt1.text=""+_pts+" pts";
						break;
					case 1:
						_q2.texture=PowerUpFactory.getTxt(PowerUpFactory.IMG1);
						_qtxt2.text=""+_pts+" pts";
						break;
					case 2:
						_q3.texture=PowerUpFactory.getTxt(PowerUpFactory.IMG1);
						_qtxt3.text=""+_pts+" pts";
						break;
				}
				
				animeretoiles(ptglobal1.x,ptglobal1.y);					
			} else {
				// mauvaise reponse
				target.label="WRONG:"+target.name;
			}
			
		}		
		private function fntickernettoyeur(evt:TimerEvent):void{
			_maclocknettoyeur.stop();
			_scanim.removeChildren(0,_scanim.numChildren-1);			
			removeChild(_scanim);
			// on lance une autre question pour voir
			newquestion();
		}
		
		private function newquestion():void{
			// stockage des x 
			_pts=100;
			_labelpts.text=""+_pts+" pts";
			_maclock.start();
			
			_xcurrentquestion=_currentquestion.y;
			_xbtn1=_btn1.x;
			_xbtn2=_btn2.x;
			_xbtn3=_btn3.x;
			_xbtn4=_btn4.x;
			
			var tween1:Tween=new Tween(_currentquestion,0.5);
			tween1.animate("y",-200);
			tween1.onComplete=finnewquestion;

			var tweenbtn1:Tween=new Tween(_btn1,0.5);
			tweenbtn1.animate("x",-500);
			Starling.juggler.add(tweenbtn1);

			var tweenbtn2:Tween=new Tween(_btn2,0.5);
			tweenbtn2.animate("x",500);
			Starling.juggler.add(tweenbtn2);

			var tweenbtn3:Tween=new Tween(_btn3,0.5);
			tweenbtn3.animate("x",-500);
			Starling.juggler.add(tweenbtn3);

			var tweenbtn4:Tween=new Tween(_btn4,0.5);
			tweenbtn4.animate("x",500);
			Starling.juggler.add(tweenbtn4);

			Starling.juggler.add(tween1);				
			
		}
		private function finnewquestion():void{
			// chgt des question
			if(_currentindexquestion<=1) {
				_currentindexquestion++;
				_currentquestion.text=partie.dataquizz.questions[_currentindexquestion].TITREQUESTION;
				_btn1.label=partie.dataquizz.questions[_currentindexquestion].REPONSE1;
				_btn2.label=partie.dataquizz.questions[_currentindexquestion].REPONSE2;
				_btn3.label=partie.dataquizz.questions[_currentindexquestion].REPONSE3;
				_btn4.label=partie.dataquizz.questions[_currentindexquestion].REPONSE3;
				// affichage
				_currentquestion.y=_xcurrentquestion;
				_btn1.x=_xbtn1;
				_btn2.x=_xbtn2;
				_btn3.x=_xbtn3;
				_btn4.x=_xbtn4;

			} else {
				// on a eu trois question c la fin on envoit les resultats au server
				// affichage ecran de resultat				
				_labelpts.visible=false;
				
				_currentquestion.text="Nombre de points gagnés :"+_score;
				if(_nbok==3){
					// affichage bonus
					_currentquestion.text="Nombre de points gagnés :"+_score+" BONUS x 3 !!!";
				}
				_currentquestion.y=_xcurrentquestion;
				// envoie les datas et pose d un timer pr évoter d aller trop vite				
				// on avertit le serveur onlance un timer et on attend un peu qd meme avant
				_clockretardserveur.start();
				var loader2:URLLoader = new URLLoader();
				loader2.addEventListener (flash.events.Event.COMPLETE, onLoaderendofgameComplete);			
				// si je suis acteur ou si j ai été défie deux url diff
				var zurl:URLRequest=new URLRequest ("http://www9.noomiz.com/om/jsonendofquizz");	
				zurl.method = URLRequestMethod.POST;
				var zdata:URLVariables=new URLVariables();
				zdata.fbid = FBUserFactory.getUser().idfb;
				zdata.idpartie= partie.dataquizz.idpartie;
				// tokeniser le code
				zdata.score=_score;
				zurl.data=zdata;
				loader2.load (zurl);
				// c est le retour du serveur qui indiquera l action
				
			}
		}
		private function onLoaderendofgameComplete(e:flash.events.Event):void{ 

			var loader:URLLoader = URLLoader(e.target);
			var zz:Object=JSON.parse(loader.data);
			// check le resultat
			// remettre à jour la partie et aller vers le bon ecran
			_responseserveur=zz.ok;
			// recup info partie depuis le serveur si besoin ?
			// => nb de points par exemple
			_nbptsfb=zz.points;
		}	
		
		private function fntickerserveur(evt:TimerEvent):void{
			_tickserveur++;
			if(_tickserveur>10){
				// pb serveur on revient au depart
				_clockretardserveur.stop();
				dispatchEventWith("complete");
			} else if(_tickserveur>3){
				switch (_responseserveur) {
					case 1:
						// ok tt est ok on va faire la page de resultat
						_clockretardserveur.stop();
						_currentquestion.text="Tu as sur ton compte :"+_nbptsfb+" Points";		
						_zztaff=setInterval(afficherbtnha,1000);
						break;
					case 0:
					default:
						// on a un un soucis serveur
						_clockretardserveur.stop();
						_currentquestion.text="Tu as sur ton compte :"+_nbptsfb+" Points";
						_zztaff=setInterval(afficherbtnha,1000);
						break;
				}
			} // on enchaine suir l ecran d achat apres un petit temps ?
			//cool ces xx pts te mermettent de ...
			
			
		}

		private function afficherbtnha():void{
			clearInterval(_zztaff);
//			animeretoiles(200,200);
			var _btnrejouer:Button=new Button();
			_btnrejouer.label="REJOUER";
			_btnrejouer.scaleX=_btnrejouer.scaleY=0;
			_btnrejouer.width=100;
			_btnrejouer.height=50;
			
			addChild(_btnrejouer);
			var tween1:Tween=new Tween(_btnrejouer,0.8);
			//tween1.animate("x",200);
			tween1.scaleTo(1);
			tween1.moveTo(50,250);
			Starling.juggler.add(tween1);				

			var _btnrecup:Button=new Button();
			_btnrecup.width=100;
			_btnrecup.height=50;
			_btnrecup.label="REcupérer \nmes cartes !";
			_btnrecup.scaleX=_btnrecup.scaleY=0;
			addChild(_btnrecup);
			var tween2:Tween=new Tween(_btnrecup,0.8);
			//tween1.animate("x",200);
			tween2.scaleTo(1);
			tween2.moveTo(250,250);
			Starling.juggler.add(tween2);			
		}
		
		private function animeretoiles(zx:uint,zy:uint):void{
			_maclocknettoyeur.start();
			addChild(_scanim);
			for (var i:uint=0;i<80;i++){
				var _imgchrono:starling.display.Image;
				var matexture2:Texture=PowerUpFactory.getTxt(PowerUpFactory.IMGSTAR32);			
				_imgchrono=new Image(matexture2);
				_imgchrono.width=50;
				_imgchrono.x=zx;
				_imgchrono.y=zy;
				_imgchrono.scaleX=1*Math.random()+1;
				_imgchrono.scaleY=_imgchrono.scaleX;
				_scanim.addChild(_imgchrono);				
				var tween1:Tween=new Tween(_imgchrono,0.8);
				//tween1.animate("x",200);
				tween1.animate("alpha",0);
				tween1.scaleTo(0);
				tween1.moveTo(500*Math.random(),500*Math.random());
				Starling.juggler.add(tween1);				
			}
			// a la fin remove
		}

	}
}