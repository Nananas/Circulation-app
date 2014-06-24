package mini;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import openfl.Assets;


class Image
{
	private var bitmapdata:BitmapData;
	private var _blitting:Bool;
	private var _source:BitmapData;
	private var _sourceRect:Rectangle;
	// @public: width
	// @public: height

	public function new (?source:String)
	{
		// do stuff with it depending on hardware/buffer
		if (source != null){
			if (MN.renderMode == RenderMode.Buffer){
				setBitmap(source);
			} 
		}
		//else {
		//	setTile(source);
		//}
	}
	
	
	/**
	 * @param target	BitmapData on which to copy the pixel
	 * @param position 	The position of the Data to draw
	 */
	public function render(position:Point)
	{
		// Blitting image
		if (_blitting)
		{
			// copyPixels(sourceBitmap: BitmapData, sourceRect: Rectangle, destPoint: Point, [alphaBitmap: BitmapData], [alphaPoint: Point], [mergeAlpha: Boolean])
			MN.buffer.copyPixels(_source, _sourceRect, position,null,null,true);
		}
	}
	
	// return a rectangular @image object
	public static function rectangle(w:Int, h:Int, ?c:Int, ?alpha:Float = 1):Image
	{
		if (c==null)
			c = MN.frontColor;
		

		var im:Image;
		var data:BitmapData = MN.createBitmap(w,h,true,c);
		im = new Image();
		im.setData(data);

		return im;
	}

	private function setBitmap(source:String)
	{
		_blitting = true;
		_source = MN.getBitmap(source);
		_sourceRect = _source.rect;
	}
	
	public function setData(data:BitmapData)
	{
		_blitting = true;
		_source = data;
		_sourceRect = _source.rect;
	}

	public static function fromData(data:BitmapData)
	{
		var i = new Image();
		i.setData(data);

		return i;
	}
	
	public var width(get_width, never):Int;
	private function get_width():Int { return Std.int(_sourceRect.width);}
	public var height(get_height, never):Int;
	private function get_height():Int { return Std.int(_sourceRect.height);}

}
