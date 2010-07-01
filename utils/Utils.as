package utils
{
	
import flash.net.navigateToURL;
import flash.net.URLRequest;	
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Bitmap;
import flash.utils.getDefinitionByName;
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

	public class Utils
	{
		public static function ranRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		public static function getURL(url:String, window:String = "_blank"):void
        {
            var req:URLRequest = new URLRequest(url);
            trace("getURL getURL getURL getURL getURL getURL", url, window);

            try
            {
                navigateToURL(req, window);
            }
            catch (e:Error)
            {
                trace("Navigate to URL failed", e.message);
            }
        }

	

		public static function returnBitmap(bmpDClass:Class):Bitmap
		{
			var bitmapD:BitmapData = new bmpDClass(1,1) as BitmapData;
			var bMap:Bitmap = new Bitmap(bitmapD);	
			/*if (ind>-1){
				d.addChildAt(bMap, ind);
			}else{
				d.addChild(bMap);
			}*/
			return bMap;
		}
	}
}