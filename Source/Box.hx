
package ;

import mini.Entity;
import mini.Image;

import flash.geom.Point;

class Box extends Entity
{
	private var _color:UInt;
	public function new (X:Int, Y:Int, w:Int, h:Int, color:UInt)
	{
		var im:Image = Image.rectangle(w,h,color);
		super(X,Y,im);
		setHitbox(w,h,false);
		_color = color;
	}

	override public function render()
	{
		// calculate new rectangle
		if (width > 0 && height > 0)
		{
			_image = Image.rectangle(width, height, _color);
			// calculate new origin point
			var renderPointY:Int = Std.int(position.y - height);
			_image.render(new Point(position.x, renderPointY));			
		}

	}

}