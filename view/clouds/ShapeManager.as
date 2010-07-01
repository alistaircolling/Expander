package view.clouds
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import org.flintparticles.common.counters.ZeroCounter;
	import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
	import org.flintparticles.twoD.renderers.PixelRenderer;
	
	import utils.Utils;
	import com.greensock.TimelineLite;
		
	
	
	public class ShapeManager extends Sprite
	{
		
		public const READY_TO_DIE:String = "readyToDie";
		
		protected var cloudsAr:Array;
		protected var altCloudsAr:Array;
		protected var mainClouds:Array;
		protected var renderer:DisplayObjectRenderer;
		protected var totalClouds:uint;
		protected var totalAltClouds:uint;
		protected var animal:String;
		protected var animator:Animator;
		protected var mainCloudsinPlace:uint;
		protected var _blurFilter:BlurFilter;
		protected var glowFilter:GlowFilter;
		protected var _dropFilter:DropShadowFilter;
		protected var _rendererHolder:Sprite;
		
		protected var altCloudsSequence:TimelineLite;
		protected var regCloudsSequence:TimelineLite;		
		protected var alternate:Boolean;
		
		public function ShapeManager(n:uint, aN:uint, s:String, a:Animator)
		{
			alternate = true;
			animator = a;
			animal = s;
			totalClouds = n;
			totalAltClouds = aN;
			init();
		}
		
		protected function init():void{
			cloudsAr = new Array();
			
			mainClouds = new Array();
			renderer = new DisplayObjectRenderer();
			_rendererHolder = new Sprite();
			addChild(_rendererHolder);
			_rendererHolder.addChild(renderer);
			_dropFilter = new DropShadowFilter(14, 45, 0xffffff, .3, 32, 32, 15, BitmapFilterQuality.HIGH, false, false, true);
			_blurFilter = new BlurFilter(16, 5, BitmapFilterQuality.HIGH);
			_rendererHolder.filters = [_dropFilter, _blurFilter];
			initClouds();
			initAltClouds();
		}
		
		public function addBlueDropShadow(c:*):void{
			var color:Number = 0x51b2d2;
			var alpha:Number = .5;//0.75;
			var blurX:Number = 10;
			var blurY:Number = 10;
			var strength:Number = 2;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			var gF:GlowFilter = new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
			TweenMax.to(c, Utils.ranRange(5, 15), {glowFilter:{color:0x51b2d2, alpha:1, blurX:10, blurY:10}});
		}
		
		public function hideClouds():void{
			alternate = false;
			var topVal:Number = totalClouds;
			for (var i:int = 1; i <=topVal; i++)
			{
				var cloud:BasicCloud = mainClouds[i] as BasicCloud;
				if (i%2==1){  
					cloud.convertToParticles(false);
				}else{
					trace("SHOULD BE ALPHAING");
					TweenMax.to(cloud, 16, {x:-600});
					TweenMax.to(cloud, 5, {alpha:0});
				}
			}
			TweenMax.delayedCall(20, destroySelf);
			if (altCloudsAr.length>0){
				hideAltClouds(); //added for alternating section
			}
			
		}
		
		
		
		
		private function destroySelf():void{
			parent.removeChild(this);
			dispatchEvent(new Event(READY_TO_DIE));
		}
	
		public function initClouds():void{
			trace(" === === === INIT CLOUDS IN SHAPE MANAGER");
			mainClouds = new Array();
			for (var i:uint = 1; i<=totalClouds; i++){	
					trace("--CREATING CLOUD:"+i+"   FOR THE:"+animal);
					var cloud:BasicCloud = new BasicCloud(i, animal , renderer);
					initMainCloud(cloud);	
					mainClouds[i] = cloud;				
			}
		}
		
		private function initAltClouds():void{
			trace("INIT ALt Cloud:"+totalAltClouds);
			altCloudsAr = new Array();
			for (var i:int = 1; i <=totalAltClouds; i++)
			{
				var altC:BasicCloud = new BasicCloud(i, animal, renderer, "Alt");
				altCloudsAr[i] = altC;
				initAltCloud(altC);
			}
		}
		
		public function initMainCloud(c:BasicCloud):void{
			c.alpha = 1;
			var xStart:Number = Utils.ranRange(600,800);
			c.x = xStart;
			c.y = 0;
			c.scaleX = 1;
			c.scaleY = 1;
			addBlueDropShadow(c);
			addChild(c);
		}
		
		private function initAltCloud(c:BasicCloud):void{
			c.alpha = 0
			addBlueDropShadow(c);
			addChild(c);
		}
		
		public function startCloudsMain():void{
			trace("> > > > > > > > start clouds main");
			for (var i:uint = 1; i<=totalClouds; i++){					
				var c:BasicCloud = mainClouds[i];
				TweenMax.to(c, Utils.ranRange(4, 10), {x:0, onComplete:cloudInPlace});
			}
		
		}
		
		protected function showRegularClouds():void{
			for (var i:uint = 1; i<=totalClouds; i++){					
				var c:BasicCloud = mainClouds[i];
				TweenMax.to(c, Utils.ranRange(.3, 6), {alpha:1, delay:1});
			}
			if(alternate){
				TweenMax.delayedCall(8, hideRegularClouds);
			}
		}
		
		protected function hideRegularClouds():void{
			for (var i:uint = 1; i<=totalClouds; i++){					
				var c:BasicCloud = mainClouds[i];
				TweenMax.to(c, Utils.ranRange(1, 4), {alpha:0, delay:2});
			}
			if(alternate){
				showAlternateClouds();
			}
		}

		private function hideAltClouds():void{
			for (var i:int = 1; i <= totalAltClouds; i++){
				var altC:BasicCloud = altCloudsAr[i];
				TweenMax.to(altC, Utils.ranRange(2, 4), {alpha:0, delay:3});
			}
			if(alternate){
				showRegularClouds();
			}
		}
		
		protected function showAlternateClouds():void{		
			for (var i:int = 1; i <= totalAltClouds; i++){
				var altC:BasicCloud = altCloudsAr[i];
				TweenMax.to(altC, Utils.ranRange(3, 5), {alpha:1});
			}
			if(alternate){
				TweenMax.delayedCall(7, hideAltClouds);
			}
		}
		
		protected function cloudInPlace():void{
			mainCloudsinPlace++;
			trace("main cloudsin place:"+mainCloudsinPlace);
			if (mainCloudsinPlace==1){
				
				hideRegularClouds();
				showAlternateClouds();
			}
		}
	}
}