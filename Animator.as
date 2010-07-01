﻿package{	import caurina.transitions.Tweener;		import com.greensock.TweenMax;	import com.greensock.easing.EaseLookup;	import com.greensock.easing.Elastic;	import com.greensock.easing.Linear;	import com.greensock.easing.Quad;	import com.greensock.plugins.*;		import flash.display.Bitmap;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.filters.BitmapFilterQuality;	import flash.filters.BlurFilter;	import flash.filters.DropShadowFilter;	import flash.filters.GlowFilter;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.utils.Timer;		import model.Model;		import org.flintparticles.twoD.renderers.PixelRenderer;		import view.FinalFrameSprite;	import view.buttons.ChoiceButton;	import view.clouds.*;	import flash.display.BitmapData;	import utils.Utils;	import flash.display.StageScaleMode;		public dynamic class Animator extends Sprite	{		//const		public const RESTART_ME:String = "restartMe";				//data		private var choices:Array;		private var currentQ:uint;		private var totalQuestions:uint;		private var theModel:Model;				//						SPRITES		//masks		private var sideEmitterMask:Sprite;		private var mainMask:Sprite;		private var pshopMask:Bitmap;				//bg sprites		private var bgBlue:Bitmap;		private var bgLeft:Bitmap;		private var bgRight:Bitmap;		private var bgFront:Bitmap;				private var questionHolder:Sprite;		private var smallBG:Bitmap;				private var sideEmittersHolder:Sprite;		private var holder:Sprite;		private var _hitArea:Sprite;						//////////////     LIBRARY SYMBOLS					private var choice1:ChoiceButton;		private var choice2:ChoiceButton;		private var or:Or;		private var lenorLogoRt:LenorLogoRt;		private var whatHeaven:WhatHeaven;		private var _finalFrame:FinalFrame;		private var catHotSpots:CatHotSpots;				private var currentClouds:Array;		private var cloudsToHide:Array;		private var bottomC:BottomCloud;					////////    FILTERS				private var _dropFilter:DropShadowFilter;		private var _blurFilter:BlurFilter;				private var _bitmapMask:BitmapData;		private var _bitmapMasker:Bitmap;				/////// CUSTOM CLASSES		private var rollOverSmoke:RolloverSmoke;		private var batManager:BatManager;		private var cakeManager:CakeManager;		private var catManager:NewCatManager;		private var currentAnimal:ShapeManager;		private var disappearingAnimal:ShapeManager;				private var currentHotSpots:*;				private var renderer:PixelRenderer;				private var sideEmitter1:SideEmitter;		private var sideEmitter2:SideEmitter;		private var sideEmitterLarge:SideEmitter;						private var bottomTween:TweenMax;				public function Animator()		{			addEventListener(Event.ADDED_TO_STAGE, init);		}				private function init(t:Event = null):void{			removeEventListener(Event.ADDED_TO_STAGE, init);			stage.scaleMode = StageScaleMode.NO_SCALE;						trace("---  INITIALISING");			//INITIALISE DATA			theModel = new Model();			currentQ = 0;			totalQuestions = 2;			currentClouds = new Array();			cloudsToHide = new Array();			initChoices();						//INITIALISE DISPLAY			TweenPlugin.activate([TintPlugin]);			initialiseDisplayObjects();			createBottomCloud();			currentClouds = new Array();			drawMainMask();			createMouseListener();						createSideEmitters();			initAnimals();			addLogo();		//	currentAnimal = catManager;			currentAnimal = batManager;			currentAnimal.startCloudsMain();			holder.addChild(currentAnimal);			showButtons(currentQ);			TweenMax.delayedCall(2, makeHotSpots);			placeBGElements();			showText();			setMainMaskSize(600,600);								}				private function createBottomCloud():void{			trace("CREATE BOTTOM CLOUD*******");			bottomC = new BottomCloud();			bottomC.x = 600;			holder.addChild(bottomC);			bottomTween = new TweenMax(bottomC, 60, {x:-600, repeat:-1});		}				private function initChoices():void		{			choices = new Array();			var c1:Array = ["butterfly", "mittens"];			var c2:Array = ["cake", "beret"];			var c3:Array = ["icecream", "bouquet"];			choices = [c1, c2, c3];		}				private function showText():void{			whatHeaven = new WhatHeaven();			whatHeaven.x = 107;			whatHeaven.y = 50;			whatHeaven.alpha = 0;			holder.addChild(whatHeaven);			TweenMax.to(whatHeaven, 3, {alpha:1, delay:3});		}				private function addLogo():void{			lenorLogoRt = new LenorLogoRt();			lenorLogoRt.x = 433;			addChild(lenorLogoRt);		}				private function initAnimals():void{		//	catManager = new NewCatManager(3, 3, "Cat", this);			batManager = new BatManager(4, 6, "Bfly", this);			cakeManager = new CakeManager(4, 5, "Ck", this);		}		private function initialiseDisplayObjects():void{			holder = new Sprite();			addChild(holder);			questionHolder = new Sprite();			addChild(questionHolder);									sideEmittersHolder = new Sprite();		}				private function initButtons():void{			choice1 = new AnimalButton();			choice2 = new AnimalButton();			choice1.x = 96;			choice1.y = 496;		//	choice1.visible = false;			addChild(choice1);												choice2.x = 329;			choice2.y = 496;		//	choice2.visible = false;			addChild(choice2);						choice1.buttonMode = true;			choice1.useHandCursor = true;			choice1.mouseChildren = false;						choice2.buttonMode = true;			choice2.useHandCursor = true;			choice2.mouseChildren = false;							choice1.addEventListener(MouseEvent.CLICK, chosen);			choice2.addEventListener(MouseEvent.CLICK, chosen);					choice1.addEventListener(MouseEvent.MOUSE_OVER, mOver);			choice2.addEventListener(MouseEvent.MOUSE_OVER, mOver);				choice1.addEventListener(MouseEvent.MOUSE_OUT, mOut);			choice2.addEventListener(MouseEvent.MOUSE_OUT, mOut);			//add the 'or'			or = new Or();			or.x = 300- (or.width/2);			or.y = 493;//-(or.height/2);			or.alpha = 0;			or.visible = false;			addChild(or);													}		private function mOver(m:MouseEvent):void{			var choice:ChoiceButton = m.currentTarget as ChoiceButton;			choice.showRollover();		}		private function mOut(m:MouseEvent):void{			var choice:ChoiceButton = m.currentTarget as ChoiceButton;			choice.showRollOut();		}				private function chosen(m:MouseEvent):void{					var cB:ChoiceButton = m.currentTarget as ChoiceButton;			var d:uint = cB.data;			trace(">Selection made:"+d+" > > > > > > > > ");				theModel.submitAnswer(d, currentQ);			disappearingAnimal = currentAnimal;			disappearingAnimal.hideClouds();//			disappearingAnimal.hideAl						hideButtons();					rollOverSmoke.removeDisplayObject();		//	disappearingAnimal.addEventListener(currentAnimal.READY_TO_DIE, removeAnimal);					//	TweenMax.delayedCall(.5, nextQuestion);			nextQuestion();		}				private function nextQuestion(e:Event = null):void{			trace("00000000000    QUICKER     00000000000 NEXTQUESTION");			if (currentQ<totalQuestions-1){				currentQ ++;								createNewAnimal();				showButtons(currentQ);				TweenMax.delayedCall(2, updateHotspots);			}else{				finalHide();				showFinalAnswer();				trace("this is the final quesition");			}		}					private function removeAnimal(e:Event = null):void{			trace("REMOVE ANIMAL THAT HAS ANIMATED OUT");		//	holder.removeChild(disappearingAnimal); //was currentAnimal		}				private function hideButtons():void{			trace("> > > > > > > > hide buttons");			TweenMax.to(choice1, .5, {blurFilter:{blurX:10, blurY:10}, autoAlpha:0, delay:.2});			TweenMax.to(or, .5, {blurFilter:{blurX:10, blurY:10}, autoAlpha:0, delay:.5});						TweenMax.to(choice2, .5, {blurFilter:{blurX:10, blurY:10}, autoAlpha:0, delay:1});		}				private function createNewAnimal():void{			trace("CREATENEWANIMAL]]]]]]]:"+currentQ);			currentAnimal = null;			switch(currentQ){				case 1://					currentAnimal = batManager;					currentAnimal = cakeManager;					break				case 2:					currentAnimal = cakeManager;					break							}			currentAnimal.startCloudsMain();			holder.addChild(currentAnimal);						}				private function updateHotspots():void{			trace("update hotspots");			makeHotSpots();		}				public function finalHide():void{			TweenMax.to(questionHolder, .5, {autoAlpha:0, blurFilter:{blurX:10, blurY:20}});			TweenMax.to(choice1, .5, {autoAlpha:0, blurFilter:{blurX:10, blurY:20}, delay:.2});			TweenMax.to(choice2, .5, {autoAlpha:0, blurFilter:{blurX:10, blurY:20, delay:.4}});					}				public function showFinalAnswer():void{			TweenMax.to(whatHeaven, 2, {alpha:0, delay:0});			TweenMax.to(lenorLogoRt, 2, {alpha:0, delay:0});						//request answer from model to know which to show			var res:uint = theModel.getResult();			_finalFrame = new FinalFrame();			addChild(_finalFrame);			_finalFrame.showResult(res);			trace("Final frame added");					}			private function createSideEmitters():void{			sideEmitter1 = new SideEmitter(60, 20, 3000);			sideEmitter1.x  = 600;			sideEmitter1.y = 30;			sideEmittersHolder.addChild(sideEmitter1);						sideEmitter2 = new SideEmitter(60, 20, 1000);			sideEmitter2.x  = 600;			sideEmitter2.y = 300;			sideEmittersHolder.addChild(sideEmitter2);						_blurFilter = new BlurFilter(25, 8, BitmapFilterQuality.HIGH);						sideEmittersHolder.filters = [_blurFilter];			//TODO nice: move side emitters about		}				private function createMouseListener():void{			_hitArea = new Sprite();			_hitArea.graphics.beginFill(0xD4C131, 1);			_hitArea.graphics.drawRect(0,0,600,600);			_hitArea.alpha =  0;			addChild(_hitArea);			_hitArea.addEventListener(MouseEvent.ROLL_OUT, rrOut);		}				private function rrOut(m:MouseEvent):void{			//add eb code here					}				private function drawMainMask():void{			mainMask = new Sprite();			mainMask.graphics.beginFill(0x25FF2D);			mainMask.graphics.drawRect(0,0,600,600);			addChild(mainMask);			holder.mask = mainMask;		}				private function makeHotSpots():void{			trace("------------------->>>>>>>     makeHotSpots q:"+currentQ);			switch(currentQ){				case 0:					currentHotSpots = new CatHotSpots();					rollOverSmoke = new RolloverSmoke();									addChild(rollOverSmoke);				//	rollOverSmoke.alpha = 0;					break				case 1:					currentHotSpots = new BatHotSpots();				break				case 2:					currentHotSpots = new CakeHotSpots();				break							}						TweenMax.delayedCall(5, setNewHotSpots);		}				private function setNewHotSpots():void{			rollOverSmoke.setDisplayObject(currentHotSpots);		}				private function removeRolloverSmoke():void{			if (rollOverSmoke != null){				rollOverSmoke.destroy();					}					try			{				removeChild(rollOverSmoke);				} 			catch (e:Error)			{							}		}				private function showButtons(n:uint):void{			trace("add buttons:"+n);												if (choice1==null){				initButtons();			}						choice1.addTitle(choices[n][0]);			choice2.addTitle(choices[n][1]);									choice1.addData(1);			choice2.addData(2);									choice1.alpha = 0;			choice1.visible = false;			choice2.alpha = 0;			choice2.visible = false;						TweenMax.to(choice1, 2, {blurFilter:{blurX:0, blurY:0}, autoAlpha:1, delay:1});			TweenMax.to(or, 2, {blurFilter:{blurX:0, blurY:0}, autoAlpha:1, delay:1.2});			TweenMax.to(choice2, 2, {blurFilter:{blurX:0, blurY:0}, autoAlpha:1, delay:1.5});					setTopDepth(choice1);			setTopDepth(or);			setTopDepth(choice2);			setTopDepth(lenorLogoRt);		}				private function setTopDepth(d:DisplayObject):void{			d.parent.setChildIndex(d, d.parent.numChildren-1);		}				private function placeBGElements():void{			trace("Place BG Elements");			bgBlue = Utils.returnBitmap(BGBlue);			bgBlue.alpha = .75;			bgLeft = Utils.returnBitmap(BGLeft);			bgRight = Utils.returnBitmap(BGRight);			bgFront = Utils.returnBitmap(BGFront);			bgBlue.alpha = 0;			bgLeft.alpha = 0;			bgRight.alpha = 0;			bgFront.alpha = 1;			bgFront.x = 600;		//	catManager.addBlueDropShadow(bgFront);			holder.addChildAt(bgBlue, 0);			holder.addChildAt(bgLeft, 0);			holder.addChildAt(bgRight, 0);			holder.addChildAt(bgFront, 0);			startBGAnim();		}				private function startBGAnim():void{			trace("startBGAnim");			Tweener.addTween(bgBlue, {alpha:1, time:1, transition:"easeInOutQuad"});			Tweener.addTween(bgLeft, {alpha:1, time:.7, transition:"easeInOutQuad"});			Tweener.addTween(bgRight, {alpha:1, time:.7, transition:"easeInOutQuad", delay:3.3});			TweenMax.to(bgFront, 50, {x:-600, ease:Linear.easeNone, repeat:-1, repeatDelay:5, delay:2});		}				private function setMainMaskSize(w:Number, h:Number):void{			trace("main mask revised:"+w+":"+h);			mainMask.graphics.clear();			mainMask.graphics.drawRect(0,0,w,w);			mainMask.alpha = 0;			if (w==600){				pshopMask = Utils.returnBitmap(PshopMask);				pshopMask.cacheAsBitmap = true;				addChild(pshopMask);				holder.mask = null;				holder.mask = pshopMask;				holder.cacheAsBitmap = true;			}else{				holder.mask = null;				removeChild(pshopMask);				hideButtons();				lenorLogoRt.alpha = 0;			}								}	}}