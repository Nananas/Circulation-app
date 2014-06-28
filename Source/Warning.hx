
package ;

import mini.Entity;
import mini.Image;

import flash.display.BitmapData;
import flash.geom.Point;

class Warning extends Entity
{
	private var _frames : Array<Image>;
	private var _currentFrame : Int;
	private var _totalFrames : Int = 4;
	private var _timer : Float;
	private var speed : Float;
	private var _time : Float = 0.1;


	public function new (X:Int, Y:Int, source:String)
	{
		super(X,Y);

		_currentFrame = 0;

		_timer = 0;

		var original = openfl.Assets.getBitmapData(source);

		var height:Int = original.height;
		var width:Int = Std.int(original.width/_totalFrames);

		_frames = new Array<Image>();

		for (i in 0..._totalFrames) {
			var f = new BitmapData(width, height, true, 0x00000000);
			f.copyPixels(original, new flash.geom.Rectangle(width*i, 0, width, height), new Point(0,0));
			var i = Image.fromData(f);
			_frames.push(i);
		}
	}


	override public function render()
	{
		_frames[_currentFrame].render(position);
	}

	override public function update(dt:Float)
	{
		_timer += dt;

		if (_timer > _time)
		{
			_timer = 0;
			_currentFrame ++;

			if (_currentFrame == _totalFrames)
			{
				_currentFrame = 0;
			}
		}
	}
}