
package mini;

import flash.geom.Point;
import flash.display.BitmapData;

class Draw 
{
	private static var _color:Int = 0xFFFFFF;

	public static function line(start:Point, end:Point):Void
	{
		var screen:BitmapData = MN.buffer;

		var t:Float = 0;

		var x:Int = Std.int(start.x);
		var y:Int = Std.int(start.y);

		var length:Int = Std.int(Math.sqrt((start.x - end.x)*(start.x - end.x) + (start.y - end.y)*(start.y - end.y)));

		var xx:Int = Std.int(end.x - start.x);
		var yy:Int = Std.int(end.y - start.y);

		// draw first pixel
		screen.setPixel(Std.int(start.x),Std.int(start.y),_color);
		while (t < length)
		{
			x = Std.int(t/length * xx + start.x);
			y = Std.int(t/length * yy + start.y);

			screen.setPixel(x,y, _color);

			t+= 0.5;
		}

		// draw last pixel
		screen.setPixel(Std.int(end.x), Std.int(end.y),0xFF0000);
	}


	// Newton is badass
	// this curve is a function of x, it will not allow two values of y for one x
	public static function curve(start:Point, end:Point, middle:Point)
	{
		var screen:BitmapData = MN.buffer;

		var C0:Float = start.y;
		var C1:Float = (end.y-C0)/(end.x-start.x);
		var C2:Float = (middle.y - C0 - C1*(middle.x - start.x)) / ((middle.x - start.x)*(middle.x - end.x));

		var t:Float = start.x;
		var x:Int = Std.int(start.x);
		var y:Int = Std.int(start.y);

		var length:Int = Std.int(end.x);

		screen.setPixel(Std.int(start.x),Std.int(start.y),_color);
		while (t<length)
		{
			t++;
			x = Std.int(t);
			y = Std.int(C0 + C1*(t-start.x) + C2*(t-start.x)*(t-end.x));
			screen.setPixel(x, y,_color);
		}
		screen.setPixel(Std.int(end.x), Std.int(end.y),_color);
	}



	public static function setColor(value:Int)
	{
		_color = 0xFF000000 & value;
	}

	private static function Sign(value:Float):Int
	{
		if (value<0)return -1;
		if (value==0)return 0;
		return 1;
	}
}