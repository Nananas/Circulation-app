import mini.Engine;
import mini.MN;
import mini.Entity;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;


class Main extends Engine
{
	function new()
	{
		super(800,500);
	}

	override public function init()
	{
		MN.scene = new Simulation();
		super.init();

		MN.stage.scaleMode = openfl.display.StageScaleMode.SHOW_ALL;
		MN.stage.align = openfl.display.StageAlign.BOTTOM;

	}
}