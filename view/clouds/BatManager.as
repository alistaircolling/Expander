package view.clouds
{
	import flash.display.Sprite;

	public class BatManager extends ShapeManager
	{
		public function BatManager(n:uint, nA:uint, s:String, a:Animator)
		{
			super(n, nA, s, a);
			//tmpSq();	
		}
		private function tmpSq():void{
			var myS:Sprite = new Sprite();
			myS.graphics.beginFill(0xffffff*Math.random());
			myS.graphics.drawRect(0,0,100,100);
			addChild(myS);
			trace("batmanager created");
		}
	}
}