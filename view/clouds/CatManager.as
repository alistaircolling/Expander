package view.clouds
{
	import caurina.transitions.Tweener;
	
	import com.greensock.*;
	import com.greensock.easing.Back;
	import com.greensock.easing.EaseLookup;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.BezierThroughPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	
//	import mx.effects.effectClasses.AnimatePropertyInstance;
	
	import utils.Utils;
	import view.Frame2;
	import view.Frame3;

	public class CatManager extends ShapeManager
	{
		
		public const HIDE_LOGO:String = "hideLogo";
		
		private var maxRightInit:int = 300;
		private var minRightInit:int = 5;
		private var maxDownInit:int = 20;
		private var minDownInit:int = 5;
		
		private var lenorLogo:LenorLogo;
		
		private var initTimeline:TimelineMax;
		private var timeToSync:Number = 19;
		private var fadeInTime:Number = 1;
		private var expandTime:Number = 4;
		private var bezierTime:Number = 1.5;	
		private var fadeOutTime:Number = .3;
		
		private var puffCloud1:PuffCloud;
		private var puffTimer:Timer;
		private var cloudsFadeTimer:Timer;
		private var reapperCloudsTimer:Timer;
		
		private var frame2:*;
		private var frame3:*;
	
		
		private var showMoreClouds:Timer;
		private var showMoreWait:int = 6000;
		
		private var howMuch:HowMuch;
		private var tellUs:TellUs;
		
		private var rollOverSmoke:RolloverSmoke;
		
		private var catHotSpots:CatHotSpots;
		
		//TODO make front cloud move on once cat is formed
		
		public function CatManager(n:uint, s:String, a:Animator)
		{			
			trace("CatManager Created");
			super(n, s, a);		
			init();	
		}
		
		override protected function init():void{
			super.init();
			mainCloudsinPlace = 0;
			TweenPlugin.activate([BezierPlugin]); 
			TweenPlugin.activate([BezierThroughPlugin]);
			OverwriteManager.init(OverwriteManager.AUTO);
		//	initFrames();
//			initMainClouds();
			startCloudsMain();
			cacheAsBitmap = true;
		}
		
		private function initFrames():void
		{
			frame2 = new Frame2Mov();
			frame2.x = 300+18;
			frame2.y = 22;
			frame3 = new Frame3Mov();		
			frame3.x = 300;	
			lenorLogo = new LenorLogo();
			lenorLogo.alpha = 0;
			lenorLogo.x = 303;
			lenorLogo.y = 250-lenorLogo.height-3;
			addChild(lenorLogo);
			TweenMax.to(lenorLogo, 1, {alpha:1});
		}
		
		private function tempAddSq():void{
			var sq:Sprite = new Sprite();
			sq.graphics.beginFill(0xFFFFFF*Math.random());
			sq.graphics.drawRect(200,200,100,100);
			sq.mouseChildren = false;
			sq.addEventListener(MouseEvent.MOUSE_OVER, mOv);
			addChild(sq);
		}
		
		private function mOv(m:MouseEvent):void{
			trace("mMove! ! ! ! ! ! ! !");
		}
		
		private function initMainClouds():void{
			
			for (var i:uint = 1; i<=totalClouds; i++){				
				var cloud:BasicCloud = new BasicCloud(i, "Cat", renderer);
				addChild(cloud);
				cloudsAr[i] = cloud;
				//cloud.x = 600;
				initMainCloud(cloud);
			}
		}
		

		
		private function reShowClouds(e:Event = null):void{
			trace("reshowClouds");
			
			reShowCloud(cloudsAr[2] as BasicCloud);
		//	moveCloudFromRight(cloudsAr[3] as BasicCloud);
		//	moveCloudFromRight(cloudsAr[3] as BasicCloud);
			reShowCloud(cloudsAr[4] as BasicCloud);
			
			showMoreClouds = new Timer(showMoreWait, 1);
			showMoreClouds.addEventListener(TimerEvent.TIMER_COMPLETE, showMoreClds); 
			showMoreClouds.start();
		}
		
		private function showMoreClds(t:TimerEvent = null):void{
			moveCloudFromFarRight(cloudsAr[1] as BasicCloud);
			moveCloudFromFarRight(cloudsAr[3] as BasicCloud);
			reShowCloud(cloudsAr[5] as BasicCloud);
		}
		private function removeBlur(c:BasicCloud):void{
			TweenMax.to(c, 0, {blurFilter:{blurX:0, blurY:0}});
		}
		
		private function moveCloudFromFarRight(c:BasicCloud):void{
			removeBlur(c);
			c.x = 600;
			c.y = 0;
			c.scaleX = 1;
			c.scaleY = 1;
			c.alpha = 1;
			TweenMax.to(c, 160, {x:-600});
		}
		
		private function moveCloudFromRight(c:BasicCloud):void{
			removeBlur(c);
			c.x = 100;
			c.y = 0;
			c.scaleX = 1;
			c.scaleY = 1;
			c.alpha = 0;
			TweenMax.to(c, 5, {alpha:1});
			TweenMax.to(c, 10+Utils.ranRange(10,15), {x:0, ease:Quint.easeOut});
		}
		
		private function reShowCloud(c:BasicCloud):void{
			c.y = 0;
			c.scaleX = 1;
			c.scaleY = 1;
			var tmpXRight:Number = Utils.ranRange(30, 100);
			c.x = 0;//tmpXRight;
			TweenMax.to(c, 3+Utils.ranRange(2, 4), { blurFilter:{blurX:0, blurY:0}, alpha:1, overwrite:true, ease:Linear.easeNone});
		}

		private function fadeBlurCloud(c:BasicCloud):void{
			TweenMax.to(c, fadeOutTime, {blurFilter:{blurX:3, blurY:3}, alpha:0, ease:Quint.easeInOut});
		}
		
		//moves a cloud directly to a location
		private function moveCloud(c:BasicCloud):void{
			TweenMax.to(c, .5, {alpha:0});
			TweenMax.to(c, 1, {x:280, y:100, blurFilter:{blurX:4, blurY:6}, overwrite:false, scaleX:.2, scaleY:.2});
		}
		private function bezierCloud(c:BasicCloud, tweenOffAfterwards:Boolean = false):void{
			if (tweenOffAfterwards){
				var bezTime:Number = bezierTime+Utils.ranRange(0, 1);
				TweenMax.to(c, bezTime, { orientToBezier:false,  bezier:[{x:150+Utils.ranRange(-50, 50), y:-160+Utils.ranRange(-40, 40), scaleX:.001*Math.random(), scaleY:.001*Math.random(), alpha:0/*Math.random()*.01*/},{x:30, y:0}, {x:0, y:0, scaleX:1, scaleY:1, alpha:1}], ease:Quint.easeInOut});
				TweenMax.to(c, 40, {x:-600, delay:bezTime+2, overwrite:false, ease:Linear.easeNone});
			}else{
				TweenMax.to(c, bezierTime+Utils.ranRange(2, 5), { orientToBezier:false,  bezier:[{x:150+Utils.ranRange(-50, 50), y:-160+Utils.ranRange(-40, 40), scaleX:.001*Math.random(), scaleY:.001*Math.random(), alpha:Math.random()*0},{x:30, y:0}, {x:0, y:0, scaleX:1, scaleY:1, alpha:1}], ease:Quint.easeInOut});	
			}
			//TweenMax.to(c, bezierTime-1, {scaleX:1, scaleY:1, delay:1, overwrite:false});
			//c.x = 0;
			//c.y = 0;
		}
		

		public function reInitialize():void
		{
			trace("reinitialize the cat");
			initializeCloudsTopRight();
		}
		
		private function initializeCloudsTopRight():void{
			trace("init clouds top right");
			for (var i:uint = 1; i<=totalClouds; i++){
				var cloud:BasicCloud = cloudsAr[i];
				//set clouds to be to the right of their destination
				var ranRight:Number = Utils.ranRange(maxRightInit, minRightInit);
				trace("RAN:"+ranRight);
				//cloud.x = 600+ranRight;
	//			cloud.x = 600+(i*120);
	
			}
			TweenMax.delayedCall(2, showInitialWords);
		}
		private function showInitialWords():void{
			howMuch = new HowMuch();
			howMuch.x = 313;
			howMuch.y = 14;
			howMuch.alpha = 0 ;
			addChild(howMuch);
			TweenMax.to(howMuch, 1, {alpha:1});
			
			tellUs = new TellUs();
			tellUs.x = 436;
			tellUs.y = 200;
			tellUs.alpha = 0;
			addChild(tellUs);
			
			TweenMax.to(tellUs, 1, {alpha:1, delay:1});
			TweenMax.delayedCall(4, hideFrame1);
		}
		
		public function hideFrame1():void
		{
			trace("hide frame 1");
			TweenMax.to(howMuch, .4, {alpha:0, overwrite:true});
			TweenMax.to(tellUs, .4, {alpha:0, overwrite:true, delay:.2});
			//gotoframe 2
			TweenMax.delayedCall(2, gotoFrame2);
		}
		
		private function gotoFrame2():void
		{
			trace("gotoFrame2");
			frame2.init();
			addChild(frame2);
			TweenMax.delayedCall(5,gotoFrame3);
		}
		public function justHideClouds():void
		{
			for (var i:uint = 1; i<=totalClouds; i++){	
				var cloud:BasicCloud = cloudsAr[i];
				Tweener.addTween(cloud, {x:-300+(i*90), time:Utils.ranRange(40,48), transition:"easeOutQuint"});
				Tweener.addTween(cloud, {alpha:0, time:Utils.ranRange(7, 10)});
			}
			
		}
		private function gotoFrame3():void
		{
			//hide cat. hide logo
		//	dispatchEvent(new Event(HIDE_LOGO));
			justHideClouds();
			TweenMax.to(lenorLogo, .3, {alpha:0});
			TweenMax.to(frame2, .3, {alpha:0});
			trace("gotoFrame3");
			frame3.init();
			addChild(frame3);
		}

		public function addSideEmitter(d:DisplayObject):void{
			trace("*******add side emitter");
			addChildAt(d, 0);
		}
		
		private function mOver(m:MouseEvent):void{
			trace("------mover");
		}

			
		public function playInitAnim():void{
			initTimeline.play();
		}
		
	}
}