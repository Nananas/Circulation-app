
package mini;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

class Input 
{
	private static var _enabled:Bool = false;
	private static var _key:Array<Bool> = new Array<Bool>();
	private static var _pressed:Array<Int> = new Array<Int>();
	private static var _released:Array<Int> = new Array<Int>();

	private static var _pressNumb:Int = 0;
	private static var _releaNumb:Int = 0;
	private static var _mouseDown:Bool = false;
	private static var _mouseUp:Bool = false;
	private static var _justMouseDown:Bool = false;
	private static var _justMouseUp:Bool = false;

	public static var lastKey:Int;

	public static function enable():Void
	{
		MN.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 2);
		MN.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 2);

		MN.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 2);
		MN.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp,false,2);

		MN.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 2);
	}

	public static function update():Void
	{
		// empty stashes
		for (i in 0..._pressNumb) {
			_pressed[i] = -1;
		}
		_pressNumb = 0;
		for (i in 0..._releaNumb) {
			_released[i] = -1;
		}
		_releaNumb = 0;

		_justMouseDown = false;
		_justMouseUp = false;
	}


	public static function check (code:Int):Bool
	{
		return _key[code];
	}

	public static function isPressed(code:Int):Bool
	{
		if (code < 0 && _pressNumb > 0) return true;
		for (i in 0..._pressNumb) {
			if (_pressed[i] == code) return true;
		}
		return false;
	}

	public static function isReleased(code:Int):Bool
	{
		if (code < 0 && _releaNumb > 0) return true;
		for (i in 0..._releaNumb) {
			if (_released[i] == code) return true;
		}
		return false;
	}

	public static function isMousePressed():Bool
	{
		return _justMouseDown;
	}

	public static function isMouseReleased():Bool
	{
		return _justMouseUp;
	}

	public static function checkMouse():Bool
	{
		return _mouseDown;
	}

	private static function onKeyDown(e:KeyboardEvent):Void
	{
		var code:Int = e.keyCode;
		lastKey = e.keyCode;

		if (!_key[code])
		{
			// add
			_key[code] = true;

			// add to pressed stash
			_pressNumb ++;
			_pressed[_pressNumb] = code;
		}
	}

	private static function onKeyUp(e:KeyboardEvent):Void
	{
		var code:Int = e.keyCode;
		if (_key[code])
		{
			// remove
			_key[code] = false;

			// add to release stash
			_releaNumb ++;
			_released[_releaNumb] = code;
		}

	}

	private static function onMouseDown(e:MouseEvent):Void
	{
		_mouseDown = true;
		_justMouseDown = true;

		// call scene onmousedown function
		MN.scene.onMouseDown(e.localX, e.localY);
	}

	private static function onMouseUp(e:MouseEvent):Void
	{
		_mouseDown = false;
		_mouseUp = true;
		_justMouseUp = true;

		MN.scene.onMouseUp(e.localX, e.localY);
	}

	private static function onMouseMove(e:MouseEvent):Void
	{
		// update mouse position
		#if flash
		MN.scene.mousePosition.setTo(e.localX, e.localY);
		#else
		MN.scene.mousePosition.x = e.localX;
		MN.scene.mousePosition.y = e.localY;
		#end
	}
}