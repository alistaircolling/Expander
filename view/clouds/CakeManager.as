package view.clouds
{
import utils.Utils;
import com.greensock.TweenMax;
import view.clouds.BasicCloud;
import flash.events.Event;
	public class CakeManager extends ShapeManager
	{
		
		private var _carryCloud:CkCarry;
		
		public function CakeManager(n:uint, nA:uint, s:String, a:Animator)
		{
			super(n, nA, s, a);
		}
	
		override public function startCloudsMain():void{
			trace("> > > > > > > > start clouds Cake");
			for (var i:uint = 1; i<=totalClouds; i++){					
				var c:BasicCloud = mainClouds[i];
				var ranT:Number = Utils.ranRange(4, 10);	
				var targX:int = 0;			
				if (i==1){
					ranT = 10;
					trace("CARRY CLOUD ADDED");
					//create the carrying cloud
					_carryCloud = new CkCarry();
					_carryCloud.x = 600;
					addChild(_carryCloud);
					TweenMax.to(_carryCloud, ranT*2.7, {x:-600});
				}else if (i==2){
					targX = -600;
					ranT = 23;
				}
				TweenMax.to(c, ranT, {x:targX, onComplete:cloudInPlace});
			}

		}	
		
		override protected function hideRegularClouds():void{
			for (var i:uint = 1; i<=totalClouds; i++){					
				var c:BasicCloud = mainClouds[i];
				if (i==3){
					trace("SHOULD BE CONVERTING TO PARTICLES");
					c.addEventListener(BasicCloud.RESET_ME, resetCloud);
					c.convertToParticles();
				}else{
					TweenMax.to(c, Utils.ranRange(1, 4), {alpha:0, delay:2});	
				}
				
			}
			if(alternate){
				showAlternateClouds();
			}
		}	
		
		
		override protected function showRegularClouds():void{
			for (var i:uint = 1; i<=totalClouds; i++){					
				var c:BasicCloud = mainClouds[i];
				if (i==3){
					//slide in from the right as was turned into particles
					TweenMax.to(c, 6, {x:0});
				}else{
					TweenMax.to(c, Utils.ranRange(.3, 3), {alpha:1, delay:Utils.ranRange(0, 3)});
				}
				
			}
			if(alternate){
				TweenMax.delayedCall(8, hideRegularClouds);
			}
		}		
		
	
		private function resetCloud(e:Event):void{
			trace("------------------   RESET CLOUD");
			removeChild(mainClouds[3]);
			var cloud:BasicCloud = new BasicCloud(3, animal , renderer);
			initMainCloud(cloud);
			mainClouds[3] = cloud;
		}
		
		
		
		
		
	}
}