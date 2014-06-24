package mini;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

class Screen
{

	////////////////////////:VARIABLES://////////////////::
	public var x(default, set_x):Int;
	private function set_x(value:Int):Int
	{
		if (x == value) return value;
		x = value;
		return x;
	}

	public var y(default, set_y):Int;
	private function set_y(value:Int):Int
	{
		if (y==value) return value;
		y = value;
		return y;
	}

	public var width(default, null):Int;
	public var height (default, null):Int;


	private var _buffers:Array<Bitmap>;
	private var _buffersSprite:Sprite;
	private var _current:Int;

	public function new()
	{
		init();

		if (MN.renderMode == RenderMode.Buffer)
		{
			MN.stage.addChild(_buffersSprite);
		}
	}

	public function init()
	{
		width = MN.width;
		height = MN.height;

		_buffersSprite = new Sprite();

		_buffers = new Array<Bitmap>();
		_buffers[0] = new Bitmap(new BitmapData(MN.width,MN.height,false,0x000000));
		_buffers[1] = new Bitmap(new BitmapData(MN.width, MN.height, false, 0x000000));

		_buffers[0].visible = true;
		_buffers[1].visible = false;

		_buffersSprite.addChild(_buffers[0]);
		_buffersSprite.addChild(_buffers[1]);

		x = y = 0;
		_current = 0;

		MN.buffer = _buffers[_current].bitmapData;
	}

	// swap current buffer to the invisible one (offscreen buffer)
	public function swap():Void
	{
		_current = 1 - _current;
		MN.buffer = _buffers[_current].bitmapData;
	}

	// refresh the invisible buffer: make it the background color
	public function refresh():Void
	{
		MN.buffer.fillRect(MN.boundaries, MN.backgroundColor);
	}

	// set the offscreen (invisible) buffer to visible, etc.
	public function redraw():Void
	{
		_buffers[_current].visible = true;
		_buffers[1 - _current].visible = false;
	}

}