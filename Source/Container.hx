
package ;

import mini.Entity;
import mini.Image;
import mini.MN;

class Container extends Entity
{
	private var _backgroundImage:Image;
	private var _buttons:Array<Button>;
	private var _sliders:Array<Slider>;
	private var _buttonCount:Int = 0;
	private var _color:UInt;
	private var _butWidth:Int;
	private var _butHeight:Int;

	public function new(X:Int, Y:Int, w:Int, h:Int, color:UInt)
	{
		_color = color;
		_butWidth = w;
		_butHeight = h;

		// background
		_backgroundImage = Image.rectangle(195,450,0xffefefef);

		super(X,Y,_backgroundImage);
		setHitbox(195,480,true);

		_buttons = new Array<Button>();
		_sliders = new Array<Slider>();
	}

	override public function update(dt:Float)
	{
		if (active)
		{
			for (i in _buttons)
			{
				i.update(dt);
			}

			for (i in _sliders)
			{
				i.update(dt);
			}
		}
	}

	override public function render()
	{
		super.render();

		// render list
		if (active){
			for (i in _buttons) {
				i.render();
			}

			for (i in _sliders)
			{
				i.render();
			}
		}
	}
	
	public function addButton(text:String, toggle:Bool = false):Button
	{
		var xx:Int = Std.int(position.x + 10);
		var yy:Int = Std.int(position.y + _butHeight *(2*_buttonCount + 1));
		var b:Button = new Button(text, xx, yy, _butWidth, _butHeight,_color,"left",toggle);
		_buttons.push(b);
		_buttonCount ++;

		return b;
	}

	public function addSlider(slider:Slider)
	{
		_sliders.push(slider);
	}

	override public function mouseDown(lx:Float, ly:Float)
	{
		// mouse down inside container
		// loop through list to check each button
		for (i in _buttons)
		{
			if (i.getHover())
			{
				// deactivate all
				deactivateAll();
				// activate
				i.setActive();
				i.DO();

			}
		}

		// pass event to all sliders
		for (i in _sliders)
		{
			i.mouseDown(lx,ly);
		}
	}

	// pass event to all sliders
	override public function mouseUp(lx:Float, ly:Float)
	{
		for (i in _sliders)
		{
			i.mouseUp(lx, ly);
		}
	}

	public function deactivateAll()
	{
		for (i in _buttons) {
			i.setActive(false);
		}
	}
}