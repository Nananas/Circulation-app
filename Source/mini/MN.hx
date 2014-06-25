package mini;

import openfl.Assets;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.Point;
import flash.text.TextFormat;
import haxe.Timer;

class MN
{

	static public var renderMode:RenderMode;
	static public var stage:Stage;
	static public var scene:Scene;
	static public var screen:Screen;
	static public var engine:Sprite;
	static public var buffer:BitmapData;
	static public var width:Int;
	static public var height:Int;

	static public var focus:Bool;

	static public var boundaries:flash.geom.Rectangle;

	static public var backgroundColor:UInt = 0xffffffff;
	static public var frontColor:Int = 0xffefefef;
#if flash
	static public var font:String = "assets/georgia";
	static public var defaultTextFormat:TextFormat = new TextFormat(font, 14, frontColor);
#else
	static public var font:String = "Georgia.ttf";
	static public var defaultTextFormat:TextFormat = new TextFormat(font, 14, frontColor);
#end


	static private var _time:Float;


	static public function getBitmap(source:String):BitmapData
	{
		// check is this bitmap already is loaded
		if (_bitmaps.exists(source))
			return _bitmaps.get(source);
		
		var data:BitmapData = Assets.getBitmapData(source);
		
		_bitmaps.set(source, data);
		
		return data;
	}
	
	static public function createBitmap(width:Int, height:Int, ?transp:Bool = false, ?color:Int):BitmapData
	{
		var c:Int;
		c = frontColor;
		if (color != null)
			c = color;

		return new BitmapData(width, height, transp, color);
	}

	static public inline function overlap(A:Entity, B:Entity):Bool
	{
		return false;
	}

	static public inline function overlapPoint(A:Entity, P:Point):Bool
	{
		return ((P.x - A.position.x < A.width) && (P.x > A.position.x) && (P.y - A.position.y < A.height) && (P.y > A.position.y));
	}

	static public inline function getElapsed():Float
	{
		var t:Float = Timer.stamp();
		var e:Float = t - _time;
		_time = t;
		return e;
	}

	public static inline function clamp(value : Float, min : Float, max : Float) : Float
	{
		if (value < min)
			return min;
		else if (value > max)
			return max;
		else
			return value;
	}

	
	static private var _bitmaps:Map<String,BitmapData> = new Map<String,BitmapData>();
}
