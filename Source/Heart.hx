
package ;

import mini.Entity;
import mini.Image;

import openfl.Assets;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

class Heart extends Entity
{

	private var _frames : Array<Image>;
	private var _currentFrame : Int;
	private var _totalFrames : Int = 6;
	private var _timer : Float;
	private var _totalTimeEachFrame : Float;
	public var speed : Float;

	private var _waitTimer : Float;
	private var _waitTime : Float;

	private var _loop : Bool;

	public function new (X:Int, Y:Int)
	{
		super(X,Y);

		_currentFrame = 0;

		// Timing
		_timer = 0;
		_totalTimeEachFrame = (1/3) / _totalFrames;
		_waitTimer = 0;
		_loop = false;
		setSpeed(60);

		// load original data
		var original = Assets.getBitmapData("assets/Heart_animation_short.png");

		var height:Int = original.height;
		var width:Int = Std.int(original.width/_totalFrames);

		// load frames
		_frames = new Array<Image>();

		for (i in 0..._totalFrames) {
			var f = new BitmapData(width, height,true,0x00000000);
			f.copyPixels(original, new Rectangle(width*i,0,width, height), new Point(0,0));
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
		if (!_loop)
		{
			_waitTimer += dt;

			if (_waitTimer > _waitTime)
			{
				_waitTimer = 0;

				// loop animation once
				_loop = true;
			}
			
		}
		else
		{
			_timer += dt;

			if (_timer > _totalTimeEachFrame)
			{
				_timer = 0;

				_currentFrame ++;

				if (_currentFrame >= _totalFrames)
				{
					_currentFrame = 0;
					_loop = false;
				}
			}
		}

	}

	public function setSpeed(value:Float)
	{
		// animation time of one loop: 1/3 second (max 180 /minute)
		_waitTime = (60/value) - 1/3;
	}

}