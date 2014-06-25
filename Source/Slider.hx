
package ;

import mini.Entity;
import mini.Text;
import mini.Image;
import mini.MN;
import mini.Input;


import flash.geom.Point;

/**
 * Movable button with value
 */
class Slider extends Entity
{
	private var _text : Text;

	private var _hover:Bool;
	private var _selected:Bool;
	private var _background:Image;
	private var _hoverImage:Image;
	private var _nonHoverImage:Image;

	private var _buttonPosition:Point;
	private var _backgroundPosition:Point;
	private var _textPosition:Point;

	private var _min : Float;
	private var _max : Float;
	private var _maxRange : Int = 150;

	private var _get : Void -> Float;
	private var _set : Float -> Void;

	public var current : Float;

	public function new (txt:String, X:Int, Y:Int, min:Float, max:Float, setAccess:Dynamic, getAccess:Dynamic)
	{
		this._min = min;
		this._max = max;

		_hover = false;
		_selected = false;

		_background = Image.rectangle(_maxRange+14,34, 0xffdedede);
		_hoverImage = Image.rectangle(10,30, 0xffd24726);
		_nonHoverImage = Image.rectangle(10,30, 0xffaaaaaa);

		_buttonPosition = new Point(X,Y+2);
		_backgroundPosition = new Point(X-2,Y);
		_textPosition = new Point(X,Y+8);

		_text = new Text(txt, "center");
		_text.setDimensions(_maxRange+14, 30);
		_text.setColor(0xffd24726);

		super(X,Y, _background);

		setHitbox(_maxRange+10,32,true);

		_get = getAccess;
		_set = setAccess;
		this.current = _get();
	}

	override public function update(dt:Float):Void
	{
		// update current from linked variable
		current = _get();

		// update button position from current
		_buttonPosition.x = position.x + (current-_min)/(_max-_min)*_maxRange;


		// update button position
		if (_selected)
		{
			_buttonPosition.x = MN.scene.mousePosition.x-5;
			_buttonPosition.x = MN.clamp(_buttonPosition.x, position.x, position.x + _maxRange);
		}

		if (MN.overlapPoint(this, MN.scene.mousePosition))
		{
			_hover = true;
		} else {
			_hover = false;	
		}

		// between min and maximum
		current = MN.clamp((_buttonPosition.x - position.x)/_maxRange * (_max-_min) + _min, _min, _max);
		_set(current);
	}

	override public function render()
	{
		// draw background
		_background.render(_backgroundPosition);

		// draw button
		if (_hover || _selected)
		{
			// draw active color: red
			_hoverImage.render(_buttonPosition);
		}
		else
		{
			// draw faint color: grey
			_nonHoverImage.render(_buttonPosition);
		}

		// draw text
		_text.render(_textPosition);
	}

	// passed along by the container
	override public function mouseDown(lx:Float, ly:Float)
	{
		if (MN.overlapPoint(this, MN.scene.mousePosition))
		{
			_selected = true;
		}
	}

	// even when not overlapping
	override public function mouseUp(lx:Float, ly:Float)
	{
		_selected = false;
	}
}