package mini;

import mini.Image;
import flash.geom.Point;

class Entity
{
	public var position:Point;
	
	private var _image:Image;
	private var _iWidth:Int;
	private var _iHeight:Int;
	private var _imageOrigin:Point;
	private var _render:Bool;
	
	public var active:Bool;

	public var width:UInt;
	public var height:UInt;
	
	public var allowMouseOverlap:Bool;
	
	public function new (X:Int = 0, Y:Int = 0, ?imageSource:Dynamic)
	{
		position = new Point(X,Y);
		init();
		loadImage(imageSource);
	}
	
	public function render():Void
	{
		if (_image != null && _render && active)
		{
			_image.render(position);
		}
	}
	
	public function update(dt:Float):Void{}

	public function setHitbox (w:Int, h:Int, mouseOver:Bool = false):Void
	{
		width = w;
		height = h;
		allowMouseOverlap = mouseOver;
	}

	// override
	public function mouseDown(lx:Float, ly:Float):Void{}

	// override
	public function mouseUp(lx:Float, ly:Float):Void{}
	

	private function loadImage(imageSource:Dynamic):Void
	{
		if (Std.is(imageSource, String))
		{
			_image = new Image(imageSource);
			
			_iWidth = _image.width;
			_iHeight = _image.height;
		}
		else if (Std.is(imageSource, Image))
		{
			_image = imageSource;

			_iWidth = _image.width;
			_iHeight = _image.height;
		}

	}
	
	private function init():Void
	{
		// initialise private variables
		allowMouseOverlap = false;
		width = _iWidth;
		height = _iHeight;
		_render = true;
		active = true;
	}
	
}
