
package mini;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.geom.Point;

class Text extends Image
{
	private var _field:TextField;
	private var _format:TextFormat;

	/**
	 * Creates a new Text field
	 * @param  text the actual text string
	 * @param  al   alignment type, string
	 * @return      
	 */
	public function new (text:String, al:String = "left")
	{
		super();
		_field = new TextField();
		_format = new TextFormat();
			_format.font = MN.defaultTextFormat.font;
			_format.size = MN.defaultTextFormat.size;
			_format.color = MN.defaultTextFormat.color;
		#if (flash || js)
			_format.align = Align(al);
		#else
			_format.align = al;
		#end

		#if flash
			_field.embedFonts = true;
		#end
	 // #if debug
	 // 	_field.border = true;
	 // #end
		_field.defaultTextFormat = _format;
		_field.text = text;
		_field.width = 1.3*_field.textWidth;
		_field.height = 1.3*_field.textHeight;
		updateSource();
	}

	public function setText(text:String)
	{
		_field.text = text;
		updateSource();
	}
	public function setColor(color:Int)
	{
		_field.textColor = color;
		updateSource();
	}

#if (flash || js)
	public function Align(al:String):TextFormatAlign
	{
		if (al=="left"){
			return TextFormatAlign.LEFT;
		}else if (al=="center"){
			return TextFormatAlign.CENTER;
		}else if (al=="right"){
			return TextFormatAlign.RIGHT;
		}
		return TextFormatAlign.LEFT;
	}
#end

	public function setDimensions(w:Int, h:Int)
	{
		_field.width = w;
		_field.height = h;
		updateSource();
	}

	private function updateSource()
	{
		_blitting = true;
		_source = new flash.display.BitmapData(Std.int(_field.width), Std.int(_field.height), true, 0x00000000);
		_source.draw(_field);
		_sourceRect = _source.rect;

	}
}