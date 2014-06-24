
package ;

import mini.Entity;
import mini.Image;
import mini.Text;
import mini.MN;

import flash.geom.Point;


class Button extends Entity
{
	public var text:Text;

	private var _hover:Bool;
	private var _active:Bool;
	private var _backgroundImage:Image;
	private var _hoverImage:Image;

	private var _hoverOffset:Point;
	private var _textOffset:Point;

	private var _function:Void->Void;
	private var _toggle:Bool;

	public function new (txt:String, X:Int, Y:Int, w:Int, h:Int,color:UInt, align:String="left", toggle:Bool = false):Void
	{
		// textfield
		text = new Text(txt,align);
		text.setDimensions(w,h);
		_backgroundImage = Image.rectangle(w,h,color);
		_hoverImage = Image.rectangle(w,2,color);
		_toggle = toggle;
		_active = false;
		super(X,Y,_backgroundImage);
		setHitbox(w,h,true);
	}

	override public function update(dt:Float):Void
	{
		// check if mouse overlaps hitbox
		if (MN.overlapPoint(this, MN.scene.mousePosition))
		{
			_hover = true;
		} else { _hover = false;}
	}

	override public function render()
	{
		// draw background if active
		// and change font color
		if (_active && _toggle)
		{
			super.render();
			text.setColor(0xFFFFFF);
		}else{
			text.setColor(0x6a6a6a);
			// draw a line beneath the text if mouse is hovering over
			if (_hover)
			{
				_hoverImage.render(position.add(new Point(0,20-_hoverImage.height)));
			}
		}


		// draw text on top
		text.render(position);
	}

	public function link(f:Dynamic):Button
	{
		_function = f;
		return this;
	}

	public function DO()
	{
		if (_function != null)	_function();
	}

	override public function mouseDown(lx:Float, ly:Float)
	{
		if (_toggle){
			toggle();
		} else {
			setActive(true);
		}
		DO();
	}


	public function getHover():Bool{ return _hover;}
	public function getActive():Bool{return _active;}
	public function setActive(value:Bool = true){_active = value;}
	
	private function toggle():Bool{
		_active = !_active;
		return _active;
	}
}